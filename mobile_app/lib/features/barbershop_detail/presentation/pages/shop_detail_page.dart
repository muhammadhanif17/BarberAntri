import 'package:flutter/material.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../discovery/domain/shop_models.dart';

/// Mockup Detail: live badge A-04/4 orang/~15mnt, katalog gaya, kapster, CTA.
class ShopDetailPage extends StatelessWidget {
  final Shop shop;
  final Future<Ticket> Function() onTakeQueue;
  final void Function(Ticket ticket) onTicketCreated;
  const ShopDetailPage({super.key, required this.shop, required this.onTakeQueue, required this.onTicketCreated});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail Barbershop')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Text(shop.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      QueueBadge(nowServing: shop.nowServing, waiting: shop.waiting, etaMin: shop.etaMin),
      const SizedBox(height: 12),
      const Text('Katalog Gaya & Kapster', style: TextStyle(fontWeight: FontWeight.w800)),
      ...mockKapsters.map((k) => ListTile(
        leading: CircleAvatar(child: Text(k.name[0])),
        title: Text(k.name), subtitle: Text(k.skill),
        trailing: Chip(label: Text(k.available ? 'Tersedia' : 'Sibuk')))),
    ]),
    bottomNavigationBar: SafeArea(child: Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButton(
        onPressed: () async {
          final t = await onTakeQueue();
          if (context.mounted) onTicketCreated(t);
        },
        child: const Text('Ambil Nomor Antrean'),
      ),
    )),
  );
}
