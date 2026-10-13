import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../domain/partner_models.dart';

/// LAYAR 02 — Daftar Antrean Real-Time.
/// A-06 sedang cukur + list menunggu (A-08 Siap Panggil, A-09 Walk-in, A-10) + jam populer.
class QueueListPage extends StatelessWidget {
  final List<PartnerTicket> queue;
  final void Function(PartnerTicket t) onTicketTap;
  const QueueListPage({super.key, required this.queue, required this.onTicketTap});

  @override
  Widget build(BuildContext context) {
    final serving = queue.where((t) => t.status == 'SERVING').firstOrNull ?? mockPartnerQueue.first;
    final waiting = queue.where((t) => t.status != 'SERVING').toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Antrean Real-Time'),
        actions: const [Chip(label: Text('WA Aktif'))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Sedang Proses/Pangkas', style: TextStyle(color: AppColors.muted)),
        Card(color: const Color(0xFFFFEDED), child: ListTile(
          title: Text('NOMOR ANTRI 01\n${serving.code}',
            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.danger)),
          subtitle: Text('${serving.customer} • Mulai 10:15 WIB\n4 orang menunggu di belakang'),
          trailing: const Chip(label: Text('Sedang Cukur')),
          onTap: () => onTicketTap(serving))),
        const SizedBox(height: 8),
        const Text('Jam Cukur Populer Hari Ini (Puncak 13:00–15:00)', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 64, child: Row(crossAxisAlignment: CrossAxisAlignment.end,
          children: [20, 35, 55, 90, 70, 40].map((h) => Expanded(
            child: Container(margin: const EdgeInsets.symmetric(horizontal: 4),
              height: h.toDouble(), decoration: BoxDecoration(
                color: h >= 90 ? AppColors.mint : const Color(0xFFCDEFE3),
                borderRadius: BorderRadius.circular(6))))).toList())),
        const SizedBox(height: 8),
        Text('Antrean Menunggu (Total: ${waiting.length})', style: const TextStyle(fontWeight: FontWeight.w800)),
        ...waiting.map((t) => Card(child: ListTile(
          leading: CircleAvatar(backgroundColor: t.isWalkIn ? Colors.orange.shade100 : const Color(0xFFE7F8F1),
            child: Text(t.code.split('-').last)),
          title: Text('${t.code} • ${t.customer}${t.isWalkIn ? " (Walk-in)" : ""}'),
          subtitle: Text('${t.service} • Kapster ${t.kapster}'),
          trailing: Chip(label: Text(t.status == 'READY' ? 'Siap Panggil' : 'Menunggu')),
          onTap: () => onTicketTap(t)))),
      ]),
    );
  }
}
