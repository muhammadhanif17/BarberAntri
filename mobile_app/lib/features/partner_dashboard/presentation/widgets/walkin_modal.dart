import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../data/partner_queue_repository.dart';
import '../pages/walkin_page.dart';

// B2B: modal kasir "+ Tambah Walk-in" -> buka WalkInPage (POST /queue/walkin,
// source=WALKIN, INCR atomik sama dgn online).
class WalkInModal extends StatelessWidget {
  const WalkInModal({super.key});
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('+ Tambah Walk-in'),
    content: const Text('Catat pelanggan offline tanpa aplikasi. Nomor urut digabung adil dengan online.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
      FilledButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => WalkInPage(repo: PartnerQueueRepository(ApiClient()))));
        },
        child: const Text('Buka Form')),
    ]);
}
