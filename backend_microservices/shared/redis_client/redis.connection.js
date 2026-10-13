'use strict';

const Redis = require('ioredis');
const logger = require('../../../shared/logger/logger');

let client;
let subscriber;

function getRedis() {
  if (!client) {
    client = new Redis(process.env.REDIS_URL || 'redis://localhost:6379', {
      maxRetriesPerRequest: 3,
      lazyConnect: false
    });
    client.on('error', (e) => logger.error({ err: e }, 'redis error'));
  }
  return client;
}

function getSubscriber() {
  if (!subscriber) {
    subscriber = new Redis(process.env.REDIS_URL || 'redis://localhost:6379', {
      maxRetriesPerRequest: 3,
      lazyConnect: false
    });
  }
  return subscriber;
}

module.exports = { getRedis, getSubscriber };
