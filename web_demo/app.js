/* State simulasi "live queue" (pengganti Redis + WS untuk demo statis).
   Kunci simulasi di localStorage agar tab pelanggan & mitra saling update saat refresh. */
const LiveQueue = (() => {
  const KEY = 'barberantri_liveq';
  const seed = () => ({
    nowServing: 'A-04', waiting: [
      { code: 'A-05', name: 'Tamu A-05', service: 'Low Fade Cut', kapster: 'Rian' },
      { code: 'A-06', name: 'Tamu A-06', service: 'French Crop', kapster: 'Anton' },
      { code: 'A-07', name: 'Gabriel', service: 'Low Fade Cut', kapster: 'Rian', mine: true },
      { code: 'A-08', name: 'Gabriel Kevin', service: 'French Crop + Hair Wash', kapster: 'Anton' },
      { code: 'A-09', name: 'Budi Santoso (Walk-in)', service: 'Classic Cut', kapster: 'Rian' },
    ],
    myTicket: { code: 'A-07', shop: 'Barbershop Vintage Cut', position: 4, etaMin: 15 }
  });
  function load() {
    try { const v = JSON.parse(localStorage.getItem(KEY)); if (v && v.waiting) return v; } catch {}
    const s = seed(); localStorage.setItem(KEY, JSON.stringify(s)); return s;
  }
  function save(s) { localStorage.setItem(KEY, JSON.stringify(s)); }
  function reset() { const s = seed(); save(s); return s; }
  function callNext() {
    const s = load();
    if (!s.waiting.length) return s;
    s.nowServing = s.waiting[0].code;
    s.waiting = s.waiting.slice(1);
    const i = s.waiting.findIndex(t => t.mine);
    s.myTicket.position = i === -1 ? 0 : i + 1;
    s.myTicket.etaMin = Math.max(0, s.myTicket.position * 5);
    save(s); return s;
  }
  function addWalkIn(name) {
    const s = load();
    const n = 9 + s.waiting.filter(w => w.code.startsWith('A-')).length;
    const code = 'A-' + String(n).padStart(2, '0');
    s.waiting.push({ code, name: name + ' (Walk-in)', service: 'Classic Cut', kapster: 'Rian' });
    save(s); return code;
  }
  return { load, save, reset, callNext, addWalkIn };
})();
function toast(msg) {
  const d = document.createElement('div');
  d.textContent = msg;
  d.style.cssText = 'position:fixed;bottom:5rem;left:50%;transform:translateX(-50%);background:#10231C;color:#fff;padding:.7rem 1.2rem;border-radius:999px;font-size:.85rem;z-index:99';
  document.body.appendChild(d); setTimeout(() => d.remove(), 2200);
}
