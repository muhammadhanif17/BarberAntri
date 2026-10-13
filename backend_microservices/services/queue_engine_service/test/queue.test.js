'use strict';
const { describe, it } = require('node:test');
const assert = require('node:assert');

// Fake Redis in-memory: cukup untuk verifikasi logika INCR atomik + SortedSet + status machine.
function createFakeRedis() {
  const kv = new Map(); const hashes = new Map(); const zsets = new Map();
  const published = [];
  const api = {
    published,
    async incr(k) { const v = (Number(kv.get(k)) || 0) + 1; kv.set(k, v); return v; },
    async hset(k, obj) { hashes.set(k, { ...(hashes.get(k) || {}), ...obj }); return 1; },
    async hgetall(k) { return { ...(hashes.get(k) || {}) }; },
    async zadd(k, score, member) {
      if (!zsets.has(k)) zsets.set(k, new Map());
      zsets.get(k).set(member, Number(score)); return 1;
    },
    async zrange(k) { return [...(zsets.get(k) || new Map()).entries()].sort((a, b) => a[1] - b[1]).map(([m]) => m); },
    async zrank(k, m) { const arr = [...(zsets.get(k) || new Map()).entries()].sort((a, b) => a[1] - b[1]).map(([x]) => x); const i = arr.indexOf(m); return i === -1 ? null : i; },
    async zrem(k, m) { return zsets.get(k)?.delete(m) ? 1 : 0; },
    pipeline() { const ops = []; const self = this; return { hset(k, o) { ops.push(['hset', k, o]); return this; }, zadd(k, s, m) { ops.push(['zadd', k, s, m]); return this; }, async exec() { const out = []; for (const [op, ...a] of ops) out.push([null, await self[op](...a)]); return out; } }; },
    async publish(ch, msg) { published.push({ ch, msg: JSON.parse(msg) }); return 1; }
  };
  return api;
}

describe('queue-engine: atomic seq + walk-in merge + state machine', async () => {
  const { QueueRepository } = require('../src/redis/queue.repository');
  const { addWalkIn } = require('../src/sync/walkin-sync.service');
  const { estimate } = require('../src/estimator/eta.service');
  const { shouldRemind, buildReminder } = require('../src/triggers/notify.trigger');

  it('100 take paralel => seq unik 1..100 (online+walkin adil)', async () => {
    const repo = new QueueRepository(createFakeRedis());
    const jobs = [];
    for (let i = 0; i < 50; i++) jobs.push(repo.takeTicket({ shopId: 'shop1', source: 'ONLINE' }));
    for (let i = 0; i < 50; i++) jobs.push(addWalkIn(repo, { shopId: 'shop1', customerName: `Walk${i}` }));
    const tickets = await Promise.all(jobs);
    const seqs = tickets.map((t) => Number(t.seq)).sort((a, b) => a - b);
    assert.deepStrictEqual(seqs, Array.from({ length: 100 }, (_, i) => i + 1));
    const codes = new Set(tickets.map((t) => t.code));
    assert.strictEqual(codes.size, 100);
  });

  it('WAITING->CALLED->SERVING->DONE valid, WAITING->DONE ditolak 409', async () => {
    const repo = new QueueRepository(createFakeRedis());
    const t = await repo.takeTicket({ shopId: 's2' });
    await assert.rejects(() => repo.setStatus(t.id, 'DONE'), /Illegal transition/);
    await repo.setStatus(t.id, 'CALLED');
    await repo.setStatus(t.id, 'SERVING');
    const done = await repo.setStatus(t.id, 'DONE');
    assert.strictEqual(done.status, 'DONE');
  });

  it('posisi live bergeser setelah SERVING + ETA + reminder H-2', async () => {
    const repo = new QueueRepository(createFakeRedis());
    const a = await repo.takeTicket({ shopId: 's3' });
    const b = await repo.takeTicket({ shopId: 's3' });
    assert.strictEqual(await repo.getPosition('s3', a.id), 1);
    assert.strictEqual(estimate(4, 15), 45);
    assert.strictEqual(shouldRemind(3), true);
    assert.strictEqual(shouldRemind(5), false);
    assert.ok(buildReminder(b, 2, 'Barber A').title.includes('A-'));
    await repo.setStatus(a.id, 'CALLED');
    await repo.setStatus(a.id, 'SERVING');
    assert.strictEqual(await repo.getPosition('s3', b.id), 1);
  });
});
