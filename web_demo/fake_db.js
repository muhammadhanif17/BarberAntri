/* Fake DB pengganti Postgres untuk demo statis malam ini.
   Tabel users: 2 akun dummy. Besok ganti FakeDB.login -> POST api_gateway /auth/login. */
const FakeDB = (() => {
  const users = [
    { phone: '0812-8599-7721', pass: 'demo123', role: 'pelanggan', name: 'Gabriel' },
    { phone: '0812-0000-0001', pass: 'mitra123', role: 'mitra', name: 'Vintage Cut Studio' },
  ];
  const KEY = 'barberantri_session';
  function login(phone, pass, wantRole) {
    const u = users.find(x => x.phone === phone && x.pass === pass);
    if (!u) return { ok: false, msg: 'Akun tidak ditemukan. Pakai akun demo di bawah.' };
    if (u.role !== wantRole) return { ok: false, msg: `Akun ini peran ${u.role}. Pindah toggle ke ${u.role}.` };
    const session = { token: 'mock-jwt-demo', role: u.role, name: u.name, phone: u.phone };
    localStorage.setItem(KEY, JSON.stringify(session));
    return { ok: true, session };
  }
  function current() {
    try { return JSON.parse(localStorage.getItem(KEY)); } catch { return null; }
  }
  function logout() { localStorage.removeItem(KEY); }
  function require(role, redirect = 'index.html') {
    const s = current();
    if (!s || (role && s.role !== role)) { location.href = redirect; return null; }
    return s;
  }
  return { login, current, logout, require, users: users.map(u => ({ phone: u.phone, role: u.role })) };
})();
