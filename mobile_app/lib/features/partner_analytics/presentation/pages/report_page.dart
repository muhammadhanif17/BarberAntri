import 'package:flutter/material.dart';
import '../../../partner_dashboard/domain/partner_models.dart';

/// LAYAR 06 — Laporan Performa Harian.
/// Rata-rata 15mnt, rating 4.8, Rp1,2jt, peak hours, performa kapster.
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Laporan Performa Harian'),
      actions: const [Chip(label: Text('Live Sync'))]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Card(child: Padding(padding: EdgeInsets.all(20), child: Column(children: [
        Text('RATA-RATA WAKTU MENUNGGU', style: TextStyle(color: Colors.grey)),
        Text('15 Menit', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF009E77))),
        Text('Turun 4 menit lebih cepat dibanding kemarin'),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Rating Rata-rata\n★ 4.8'), Text('Pendapatan Harian\nRp1,2jt'),
        ]),
      ]))),
      const SizedBox(height: 8),
      const Text('Analisis Jam Sibuk (Peak Hours)', style: TextStyle(fontWeight: FontWeight.w800)),
      const Text('Distribusi volume pelanggan per jam', style: TextStyle(color: Colors.grey, fontSize: 12)),
      SizedBox(height: 110, child: Row(crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          _Bar('10.00', 40), _Bar('12.00', 60), _Bar('14.00', 110),
          _Bar('16.00', 70), _Bar('18.00', 45),
        ])),
      const Text('Jam paling ramai pada pukul 14.00 – 16.00 (18 pelanggan)',
        style: TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 8),
      const Text('Performa Kapster Hari Ini', style: TextStyle(fontWeight: FontWeight.w800)),
      ...mockPerf.map((p) => Card(child: ListTile(
        title: Text(p.name), trailing: Text('Rp${p.revenue}',
          style: const TextStyle(fontWeight: FontWeight.w800))))),
    ]),
  );
}

class _Bar extends StatelessWidget {
  final String label; final double h;
  const _Bar(this.label, this.h);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(height: h, margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(color: h >= 100 ? const Color(0xFF00C896) : const Color(0xFFCDEFE3),
          borderRadius: BorderRadius.circular(8))),
      Text(label, style: const TextStyle(fontSize: 10)),
    ]));
}
