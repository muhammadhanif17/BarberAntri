'use strict';

/**
 * Status machine: WAITING -> CALLED -> SERVING -> DONE | CANCELLED
 * CANCELLED bisa dari WAITING / CALLED.
 */
const TRANSITIONS = {
  WAITING: ['CALLED', 'CANCELLED'],
  CALLED: ['SERVING', 'CANCELLED'],
  SERVING: ['DONE', 'CANCELLED'],
  DONE: [],
  CANCELLED: []
};

function canTransition(from, to) {
  return (TRANSITIONS[from] || []).includes(to);
}

function assertTransition(from, to) {
  if (!canTransition(from, to)) {
    const err = new Error(`Illegal transition ${from} -> ${to}`);
    err.statusCode = 409;
    throw err;
  }
}

module.exports = { TRANSITIONS, canTransition, assertTransition };
