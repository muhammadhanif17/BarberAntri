import 'package:flutter/material.dart';
// B2C: tiket digital A-08 + posisi live + ETA. Subscribe WS shop:{id}.
class LiveTrackingPage extends StatelessWidget {
  final String ticketCode; final int position; final int etaMin;
  const LiveTrackingPage({super.key, required this.ticketCode, required this.position, required this.etaMin});
  @override Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('Tiket $ticketCode')),
        body: Center(child: Text('Posisi $position • ETA $etaMin mnt')));
}
