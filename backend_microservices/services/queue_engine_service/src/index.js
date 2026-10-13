'use strict';

require('dotenv').config();
const Fastify = require('fastify');
const cors = require('@fastify/cors');
const config = require('./config');
const logger = require('../../../shared/logger/logger');
const { getRedis } = require('../../../shared/redis_client/redis.connection');
const { QueueRepository } = require('./redis/queue.repository');
const { registerQueueRoutes } = require('./routes/queue.routes');
const { attachWebSocket } = require('./websocket/gateway');

async function build() {
  const app = Fastify({ logger: false });
  await app.register(cors, { origin: true });
  const repo = new QueueRepository(getRedis());
  await registerQueueRoutes(app, repo, { avgDurationMin: config.avgDurationMin });
  app.get('/health', async () => ({ ok: true, service: 'queue-engine' }));
  app.setErrorHandler((err, _req, reply) => {
    logger.error({ err }, 'queue-engine error');
    reply.code(err.statusCode || 500).send({ error: err.message || 'internal' });
  });
  attachWebSocket(app.server, repo);
  return { app, repo };
}

if (require.main === module) {
  build().then(({ app }) => {
    app.listen({ port: config.port, host: '0.0.0.0' }).then(async () => {
      logger.info(`queue-engine on :${config.port}`);
    });
  }).catch((e) => { logger.error(e); process.exit(1); });
}

module.exports = { build };
