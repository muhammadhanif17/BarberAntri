import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../domain/partner_models.dart';
import '../../data/partner_queue_repository.dart';

/// LAYAR 01 — Dashboard Mitra Utama.
/// A-06 sedang dicukur, berikutnya A-08, 15 menunggu, 35 tamu + aksi cepat + status kursi.
class DashboardPage extends StatefulWidget {
  final PartnerQueueRepository repo;
  final VoidCallback onOpenWalkIn;
  final void Function(PartnerTicket t) onTicketTap;
  const DashboardPage({super.key, required this.repo, required this.onOpenWalkIn, required this.onTicketTap});
  @override State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<PartnerTicket> queue = mockPartnerQueue;

  @override
  void initState() {
    super.initState();
    widget.repo.fetchQueue('shop-vintage').then((v) => mounted ? setState(() => queue = v) : null);
  }

  Future<void> _callNext() async {
    final next = queue.where((t) => t.status != 'SERVING').firstOrNull;
    if (next == null) return;
    await widget.repo.oneTap(next.id, 'call'); // → WS broadcast + reminder H-2
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${next.code} dipanggil')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vintage Cut Studio'), leading: const CircleAvatar(child: Text('VC'))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Chip(label: Text('MITRA AKTIF • Status: Online Open', style: TextStyle(color: AppColors.mintDark))),
      Card(color: const Color(0xFF10231C), child: Padding(padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text('ANTREAN SEDANG BERJALAN', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const Text('A-06', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
          const Text('Rian "The Razor" • Low Fade Cut', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text('Berikutnya\nA-08', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
            Text('Menunggu\n15 Orang', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
            Text('Total Hari Ini\n35 Tamu', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ]),
        ]))),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _quick(Icons.person_add, 'Input\nWalk-in', widget.onOpenWalkIn),
        _quick(Icons.campaign, 'Panggil\nNext', _callNext),
        _quick(Icons.people, 'Data\nKapster', () {}),
        _quick(Icons.settings, 'Setelan\nToko', () {}),
      ]),
      const SizedBox(height: 8),
      const Text('Status Kursi & Kapster', style: TextStyle(fontWeight: FontWeight.w800)),
      ...mockSeats.map((s) => Card(child: ListTile(
        leading: CircleAvatar(child: Text(s.name[0])),
        title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(s.desc),
        trailing: Chip(label: Text(s.info, style: const TextStyle(fontSize: 11)))))),
    ]),
  );

  Widget _quick(IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Column(children: [
      CircleAvatar(backgroundColor: const Color(0xFFE7F8F1),
        child: Icon(icon, color: AppColors.mintDark)),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
    ]));
}
