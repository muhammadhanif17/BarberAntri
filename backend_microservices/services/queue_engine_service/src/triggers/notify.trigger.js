'use strict';

/**
 * Notify trigger: jika posisi tinggal <=3, kembalikan payload
 * untuk notification_service (FCM + WA Business API).
 * Dipanggil setelah takeTicket / setStatus(CALLED).
 */
function shouldRemind(position) {
  return position !== null && position >= 1 && position <= 3;
}

function buildReminder(ticket, position, shopName = '') {
  return {
    type: 'QUEUE_ALMOST',
    ticketId: ticket.id,
    code: ticket.code,
    position,
    phone: ticket.phone || null,
    title: `Antrean ${ticket.code} tinggal ${position - 1} lagi!`,
    body: `Silakan menuju ke ${shopName || ticket.shopId}. Giliran hampir tiba.`
  };
}

module.exports = { shouldRemind, buildReminder };
