import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../discovery/domain/shop_models.dart';

/// Mockup E-Ticket: A-07, posisi 4 orang lagi, checklist status,
/// toggle WA reminder, QR, Batalkan. Live update via WS shop:{id}.
class ETicketPage extends StatefulWidget {
  final Ticket ticket;
  final Stream<Map>? liveStream; // dari QueueSocketClient.stream
  const ETicketPage({super.key, required this.ticket, this.liveStream});
  @override State<ETicketPage> createState() => _ETicketPageState();
}

class _ETicketPageState extends State<ETicketPage> {
  late int position;
  bool waReminder = true;

  @override
  void initState() {
    super.initState();
    position = widget.ticket.position;
    widget.liveStream?.listen((_) { if (mounted) setState(() => position = (position - 1).clamp(0, 99)); });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('E-Tiket Antrean')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Text(widget.ticket.shopName, style: const TextStyle(color: AppColors.muted)),
        Text(widget.ticket.code, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: AppColors.mintDark)),
        Chip(label: Text('Posisi: $position orang lagi')),
        const SizedBox(height: 8),
        QrImageView(data: widget.ticket.code, size: 140),
      ]))),
      SwitchListTile(value: waReminder, onChanged: (v) => setState(() => waReminder = v),
        title: const Text('Pengingat WhatsApp Otomatis')),
      const Card(child: ListTile(title: Text('1. Menunggu di Ruang Tunggu\n2. Datang (H-2 dipanggil)\n3. Duduk di Kursi Kapster'))),
      FilledButton.tonal(onPressed: () => Navigator.pop(context),
        style: FilledButton.styleFrom(foregroundColor: AppColors.danger),
        child: const Text('Batalkan Antrean')),
    ]),
  );
}
