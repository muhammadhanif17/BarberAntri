'use strict';

const { addWalkIn } = require('../sync/walkin-sync.service');
const { estimateForTicket } = require('../estimator/eta.service');
const { shouldRemind, buildReminder } = require('../triggers/notify.trigger');

async function registerQueueRoutes(app, repo, opts) {
  const avg = opts.avgDurationMin || 15;

  app.post('/queue/take', async (req, reply) => {
    const t = await repo.takeTicket({ ...req.body, source: 'ONLINE' });
    const { position, etaMin } = await estimateForTicket(repo, t.shopId, t.id, avg);
    const reminder = shouldRemind(position) ? buildReminder(t, position) : null;
    return reply.code(201).send({ ticket: t, position, etaMin, reminder });
  });

  app.post('/queue/walkin', async (req, reply) => {
    const t = await addWalkIn(repo, req.body);
    const { position, etaMin } = await estimateForTicket(repo, t.shopId, t.id, avg);
    return reply.code(201).send({ ticket: t, position, etaMin });
  });

  app.get('/queue/:shopId', async (req) => {
    return { waiting: await repo.listWaiting(req.params.shopId) };
  });

  app.get('/queue/position/:shopId/:ticketId', async (req) => {
    const { position, etaMin } = await estimateForTicket(repo, req.params.shopId, req.params.ticketId, avg);
    return { position, etaMin };
  });

  for (const action of ['call', 'start', 'finish', 'cancel']) {
    const next = { call: 'CALLED', start: 'SERVING', finish: 'DONE', cancel: 'CANCELLED' }[action];
    app.post(`/queue/:ticketId/${action}`, async (req) => {
      const t = await repo.setStatus(req.params.ticketId, next);
      let extra = {};
      if (next === 'CALLED') {
        const pos = await repo.getPosition(t.shopId, t.id);
        if (shouldRemind(pos)) extra = { reminder: buildReminder(t, pos) };
      }
      return { ticket: t, ...extra };
    });
  }
}

module.exports = { registerQueueRoutes };
