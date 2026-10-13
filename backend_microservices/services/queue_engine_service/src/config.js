'use strict';
require('dotenv').config();
module.exports = {
  port: Number(process.env.QUEUE_PORT || 3003),
  redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
  avgDurationMin: Number(process.env.AVG_DURATION_MIN || 15)
};
