'use strict';

// ETA = avgDurationMenit * posisi. avgDuration dari queue_logs Postgres per kapster.
function estimate(position, avgDurationMin = 15) {
  if (position === null || position === undefined) return null;
  return Math.max(0, (position - 1) * avgDurationMin);
}

async function estimateForTicket(repo, shopId, ticketId, avgDurationMin) {
  const pos = await repo.getPosition(shopId, ticketId);
  return { position: pos, etaMin: estimate(pos, avgDurationMin) };
}

module.exports = { estimate, estimateForTicket };
