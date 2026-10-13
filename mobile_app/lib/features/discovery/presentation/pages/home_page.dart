import 'package:flutter/material.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../discovery/domain/shop_models.dart';

/// Mockup Home B2C: greeting, kartu antrean aktif A-07, banner, rekomendasi.
class HomePage extends StatelessWidget {
  final String userName;
  final Ticket? activeTicket;
  final void Function(Shop shop) onShopTap;
  const HomePage({super.key, required this.userName, required this.onShopTap, this.activeTicket});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Halo, $userName')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      if (activeTicket != null)
        Card(color: const Color(0xFF10231C),
          child: ListTile(title: Text('ANTREAN AKTIF ${activeTicket!.code}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            subtitle: Text('${activeTicket!.shopName} • Estimasi ~${activeTicket!.etaMin} mnt',
              style: const TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.qr_code, color: Colors.white))),
      Card(child: ListTile(title: const Text('POTONG TANPA ANTRI', style: TextStyle(fontWeight: FontWeight.w800)),
        subtitle: const Text('Ambil nomor dari mana saja'), trailing: const Icon(Icons.content_cut))),
      const SizedBox(height: 8),
      const Text('Rekomendasi Barbershop', style: TextStyle(fontWeight: FontWeight.w800)),
      ...mockShops.map((s) => ShopCard(name: s.name, rating: s.rating, distance: s.distance, onTap: () => onShopTap(s))),
    ]),
  );
}
