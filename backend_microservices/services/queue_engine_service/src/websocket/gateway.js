'use strict';

const { WebSocketServer } = require('ws');
const { getSubscriber } = require('../../../shared/redis_client/redis.connection');

/**
 * WS Gateway: room per shopId.
 * Client: wss://host/queue?shopId=xxx  -> terima JSON {event, ticket, position, etaMin}
 * Redis pub/sub channel shop:{id}:queue:update diforward ke semua socket room tsb.
 */
function attachWebSocket(server, repo) {
  const wss = new WebSocketServer({ server, path: '/queue' });
  const rooms = new Map(); // shopId -> Set<ws>
  const sub = getSubscriber();

  sub.psubscribe('shop:*:queue:update').catch(() => {});
  sub.on('pmessage', (_pattern, channel, message) => {
    const shopId = channel.split(':')[1];
    const peers = rooms.get(shopId);
    if (!peers) return;
    for (const ws of peers) {
      if (ws.readyState === 1) ws.send(message);
    }
  });

  wss.on('connection', (ws, req) => {
    const shopId = new URL(req.url, 'http://x').searchParams.get('shopId');
    if (!shopId) { ws.close(1008, 'shopId required'); return; }
    if (!rooms.has(shopId)) rooms.set(shopId, new Set());
    rooms.get(shopId).add(ws);
    ws.on('close', () => rooms.get(shopId)?.delete(ws));
  });

  return { wss, rooms };
}

module.exports = { attachWebSocket };
