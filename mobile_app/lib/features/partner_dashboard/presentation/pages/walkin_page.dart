import 'package:flutter/material.dart';
import '../../domain/partner_models.dart';
import '../../data/partner_queue_repository.dart';

/// LAYAR 05 — Input Pelanggan Walk-in (Offline Customer).
/// Nama + No WA + pilih layanan + kapster → POST /queue/walkin (INCR atomik sama dgn online).
class WalkInPage extends StatefulWidget {
  final PartnerQueueRepository repo;
  const WalkInPage({super.key, required this.repo});
  @override State<WalkInPage> createState() => _WalkInPageState();
}

class _WalkInPageState extends State<WalkInPage> {
  final name = TextEditingController(text: 'Budi Santoso');
  final phone = TextEditingController(text: '0813-2244-9988');
  int serviceIdx = 0;
  bool sendWa = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Input Pelanggan Walk-in'),
      actions: const [Chip(label: Text('Offline Customer'))]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Nama Lengkap Pelanggan'), TextField(controller: name,
        decoration: const InputDecoration(border: OutlineInputBorder())),
      const SizedBox(height: 12),
      const Text('Nomor WhatsApp (Untuk Notifikasi)'), TextField(controller: phone,
        decoration: const InputDecoration(border: OutlineInputBorder())),
      const SizedBox(height: 12),
      const Text('Pilih Model / Layanan', style: TextStyle(fontWeight: FontWeight.w800)),
      Row(children: List.generate(mockServices.length, (i) {
        final s = mockServices[i];
        return Expanded(child: Card(color: i == serviceIdx ? const Color(0xFFE7F8F1) : null,
          child: InkWell(onTap: () => setState(() => serviceIdx = i),
            child: Padding(padding: const EdgeInsets.all(12),
              child: Text('${s.name}\nRp${s.price}', textAlign: TextAlign.center))))));
      })),
      const SizedBox(height: 12),
      const Text('Tugaskan Kapster'),
      const Card(child: ListTile(title: Text('Rian "The Razor" (Estimasi siap: 12mnt)'))),
      CheckboxListTile(value: sendWa, onChanged: (v) => setState(() => sendWa = v ?? true),
        title: const Text('Simpan & Kirim Pesan Konfirmasi WA Otomatis')),
      FilledButton(
        onPressed: () async {
          final t = await widget.repo.addWalkIn(shopId: 'shop-vintage',
            name: name.text, phone: phone.text,
            service: mockServices[serviceIdx].name);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.code} ditambah (${t.customer})')));
            Navigator.pop(context, t);
          }
        },
        child: const Text('+ Tambah Antrean (A-09)'),
      ),
    ]),
  );
}
