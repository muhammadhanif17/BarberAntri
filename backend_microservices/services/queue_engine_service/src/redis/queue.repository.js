'use strict';

const { assertTransition } = require('../state/status-machine');

function todayKey(d = new Date()) {
  return d.toISOString().slice(0, 10).replace(/-/g, '');
}
const queueKey = (shopId, date) => `queue:${shopId}:${date}`;
const seqKey = (shopId, date) => `queue:seq:${shopId}:${date}`;
const ticketKey = (ticketId) => `ticket:${ticketId}`;
const channelFor = (shopId) => `shop:${shopId}:queue:update`;

function ticketCode(seq) {
  return `A-${String(seq).padStart(2, '0')}`;
}

/**
 * QueueRepository — satu-satunya penulis nomor urut.
 * Online (POST /queue/take) dan walk-in (POST /queue/walkin)
 * WAJIB lewat takeTicket() agar INCR atomik, adil, tanpa tabrakan.
 */
class QueueRepository {
  constructor(redis) {
    this.redis = redis;
  }

  async takeTicket({ shopId, kapsterId, serviceId, customerName, phone, source = 'ONLINE', date = todayKey() }) {
    const seq = await this.redis.incr(seqKey(shopId, date));
    const ticketId = `${shopId}-${date}-${seq}`;
    const code = ticketCode(seq);
    const now = new Date().toISOString();
    const ticket = {
      id: ticketId, code, shopId, kapsterId: kapsterId || '', serviceId: serviceId || '',
      customerName: customerName || '', phone: phone || '',
      source, status: 'WAITING', seq: String(seq), createdAt: now, updatedAt: now
    };
    const pipe = this.redis.pipeline();
    pipe.hset(ticketKey(ticketId), ticket);
    pipe.zadd(queueKey(shopId, date), seq, ticketId);
    await pipe.exec();
    await this.publish(shopId, { event: 'ticket.created', ticket });
    return ticket;
  }

  async getTicket(ticketId) {
    const h = await this.redis.hgetall(ticketKey(ticketId));
    return Object.keys(h).length ? { ...h, seq: Number(h.seq) } : null;
  }

  async getPosition(shopId, ticketId, date = todayKey()) {
    const rank = await this.redis.zrank(queueKey(shopId, date), ticketId);
    if (rank === null) return null;
    // rank 0 = terdepan; yang SERVING sudah di-remove dari set saat start
    return rank + 1;
  }

  async listWaiting(shopId, date = todayKey()) {
    const ids = await this.redis.zrange(queueKey(shopId, date), 0, -1);
    if (!ids.length) return [];
    const pipe = this.redis.pipeline();
    ids.forEach((id) => pipe.hgetall(ticketKey(id)));
    const rows = await pipe.exec();
    return rows.map(([e, h]) => ({ ...h, seq: Number(h.seq) }));
  }

  async setStatus(ticketId, next) {
    const t = await this.getTicket(ticketId);
    if (!t) { const e = new Error('Ticket not found'); e.statusCode = 404; throw e; }
    assertTransition(t.status, next);
    const now = new Date().toISOString();
    await this.redis.hset(ticketKey(ticketId), { status: next, updatedAt: now });
    // Keluar dari SortedSet saat mulai dilayani / selesai / batal
    // agar ZRANK = posisi live yang akurat.
    if (['SERVING', 'DONE', 'CANCELLED'].includes(next)) {
      await this.redis.zrem(queueKey(t.shopId, todayKey()), ticketId).catch(() => {});
    }
    const updated = await this.getTicket(ticketId);
    await this.publish(t.shopId, { event: `ticket.${next.toLowerCase()}`, ticket: updated });
    return updated;
  }

  async publish(shopId, payload) {
    return this.redis.publish(channelFor(shopId), JSON.stringify(payload));
  }

  /** Re-hydrate Redis dari Postgres setelah restart (dipanggil di boot). */
  async rehydrate(shopId, rows, date = todayKey()) {
    // rows: [{ticketId, seq}] yang masih WAITING/CALLED
    if (!rows.length) return;
    const pipe = this.redis.pipeline();
    rows.forEach((r) => pipe.zadd(queueKey(shopId, date), r.seq, r.ticketId));
    await pipe.exec();
  }
}

module.exports = { QueueRepository, queueKey, seqKey, ticketKey, channelFor, ticketCode, todayKey };
