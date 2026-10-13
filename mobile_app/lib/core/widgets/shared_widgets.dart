import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge live: "A-04 • 4 Orang • ~15 mnt" (mockup Detail).
class QueueBadge extends StatelessWidget {
  final String nowServing; final int waiting; final int etaMin;
  const QueueBadge({super.key, required this.nowServing, required this.waiting, required this.etaMin});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFE7F8F1), borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _item('SEDANG', nowServing, AppColors.mintDark),
        _item('ANTRI', '$waiting Orang', AppColors.ink),
        _item('ESTIMASI', '~$etaMin mnt', AppColors.ink),
      ]),
    );
  }
  Widget _item(String label, String value, Color c) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.w700)),
    Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: c)),
  ]);
}

/// Kartu rekomendasi barbershop (mockup Home).
class ShopCard extends StatelessWidget {
  final String name; final double rating; final String distance; final VoidCallback? onTap;
  const ShopCard({super.key, required this.name, required this.rating, required this.distance, this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text('★ $rating • $distance'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: onTap));
}
