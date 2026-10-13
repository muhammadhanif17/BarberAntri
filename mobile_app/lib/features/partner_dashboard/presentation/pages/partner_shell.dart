import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../data/partner_queue_repository.dart';
import '../../domain/partner_models.dart';
import 'dashboard_page.dart';
import 'queue_list_page.dart';
import 'ticket_detail_page.dart';
import 'actions_page.dart';
import 'walkin_page.dart';
import '../../../partner_analytics/presentation/pages/report_page.dart';

/// Shell B2B: bottom nav Dashboard | Antrean | + | Laporan | Aksi (mockup).
/// Semua tab berbagi 1 PartnerQueueRepository -> queue-engine yang sama.
class PartnerShell extends StatefulWidget {
  const PartnerShell({super.key});
  @override State<PartnerShell> createState() => _PartnerShellState();
}

class _PartnerShellState extends State<PartnerShell> {
  int idx = 0;
  late final repo = PartnerQueueRepository(ApiClient());
  List<PartnerTicket> queue = mockPartnerQueue;

  void _openTicket(PartnerTicket t) => Navigator.push(context, MaterialPageRoute(
    builder: (_) => TicketDetailPage(ticket: t, repo: repo)));

  void _openWalkIn() async {
    final added = await Navigator.push(context,
      MaterialPageRoute(builder: (_) => WalkInPage(repo: repo)));
    if (added is PartnerTicket && mounted) {
      setState(() => queue = [...queue, added]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(repo: repo, onOpenWalkIn: _openWalkIn, onTicketTap: _openTicket),
      QueueListPage(queue: queue, onTicketTap: _openTicket),
      const SizedBox.shrink(), // slot tombol + tengah, tidak dipakai sebagai halaman
      const ReportPage(),
      const ActionsPage(),
    ];
    return Scaffold(
      body: idx == 2 ? pages[0] : pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          if (i == 2) { _openWalkIn(); return; } // tombol + tengah = walk-in
          setState(() => idx = i);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Antrean'),
          NavigationDestination(icon: Icon(Icons.add_circle, size: 32), label: '+'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
