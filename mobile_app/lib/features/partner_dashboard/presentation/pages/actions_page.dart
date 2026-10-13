import 'package:flutter/material.dart';
import '../../domain/partner_models.dart';

/// LAYAR 04 — Manajemen Aksi Antrean.
/// Buka/tutup sesi, WA masal, istirahat toko, editor layanan.
class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});
  @override State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  bool sessionOpen = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manajemen Aksi Antrean')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: SwitchListTile(value: sessionOpen, onChanged: (v) => setState(() => sessionOpen = v),
        title: Text(sessionOpen ? 'Status Sesi: Buka Antrean' : 'Status Sesi: Tutup / Istirahat'),
        subtitle: const Text('Menerima pelanggan online & offline'))),
      Card(child: ListTile(title: const Text('Input Walk-in Manual'),
        subtitle: const Text('Catat pelanggan datang langsung'), trailing: const Icon(Icons.chevron_right))),
      Card(child: ListTile(title: const Text('Kirim Pengingat WA Masal'),
        subtitle: const Text('Ingatkan 4 antrean terdepan sekaligus'),
        trailing: FilledButton.tonal(onPressed: () =>
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WA masal terkirim (mock)'))),
          child: const Text('Kirim')))),
      Card(child: ListTile(title: const Text('Tutup Antrean / Istirahat Toko'),
        subtitle: const Text('Kunci pendaftaran sementara'), trailing: const Icon(Icons.chevron_right))),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        Text('Editor Layanan Aktif', style: TextStyle(fontWeight: FontWeight.w800)),
        Text('+ Tambah', style: TextStyle(color: Color(0xFF009E77))),
      ]),
      ...mockServices.map((s) => Card(child: ListTile(
        title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(s.duration), trailing: Text('Rp${s.price}', style: const TextStyle(fontWeight: FontWeight.w800))))),
    ]),
  );
}
