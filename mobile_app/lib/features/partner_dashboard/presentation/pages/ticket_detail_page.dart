import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../domain/partner_models.dart';
import '../../data/partner_queue_repository.dart';

/// LAYAR 03 — Kendali Detail Tiket (One-Tap Control).
/// Panggil → Mulai Cukur → Selesai | Batalkan. Tiap aksi publish WS + trigger FCM/WA.
class TicketDetailPage extends StatefulWidget {
  final PartnerTicket ticket;
  final PartnerQueueRepository repo;
  const TicketDetailPage({super.key, required this.ticket, required this.repo});
  @override State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late String status;
  @override void initState() { super.initState(); status = widget.ticket.status; }

  Future<void> _act(String act, String next) async {
    await widget.repo.oneTap(widget.ticket.id, act);
    setState(() => status = next);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.ticket.code}: $next')));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.ticket;
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pelanggan ${t.code}')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Text('NOMOR GILIRAN PELANGGAN'),
          Text(t.code, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: AppColors.mintDark)),
          Text('${t.customer} • ${t.phone}\n${t.service} • Rp${t.price} • Kapster ${t.kapster}', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Chip(label: Text('Pengingat WA Terkirim ✓', style: TextStyle(color: AppColors.mintDark))),
        ]))),
        const Card(child: Padding(padding: EdgeInsets.all(12),
          child: Text('Progres Alur Cukur:\n1. Panggil Pelanggan — Selesai\n2. Duduk di Kursi & Cukur — ${status == "SERVING" ? "Berjalan" : "Hampir Giliran"}\n3. Selesai & Pembayaran'))),
        FilledButton(onPressed: () => _act('start', 'SERVING'), child: const Text('Mulai Cukur')),
        FilledButton.tonal(onPressed: () => _act('finish', 'DONE'), child: const Text('Selesai')),
        TextButton(onPressed: () => _act('cancel', 'CANCELLED'),
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Batalkan Antrean')),
      ]),
    );
  }
}
