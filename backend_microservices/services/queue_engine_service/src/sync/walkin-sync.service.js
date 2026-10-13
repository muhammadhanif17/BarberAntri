'use strict';

/**
 * Walk-in sync — kasir input pelanggan offline tanpa aplikasi.
 * Tetap lewat QueueRepository.takeTicket(source=WALKIN) sehingga
 * nomor urut satu pintu (INCR atomik), adil vs ONLINE.
 */
async function addWalkIn(repo, { shopId, customerName, phone, kapsterId, serviceId }) {
  if (!shopId) { const e = new Error('shopId required'); e.statusCode = 400; throw e; }
  return repo.takeTicket({
    shopId, kapsterId, serviceId,
    customerName: customerName || 'Walk-in',
    phone: phone || '',
    source: 'WALKIN'
  });
}

module.exports = { addWalkIn };
