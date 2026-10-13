import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

// Live queue client: dengarkan channel shop:{id}, fallback polling jika putus.
class QueueSocketClient {
  final String baseUrl; // wss://api.barberantri.id
  WebSocketChannel? _ch;
  final _ctrl = StreamController<Map>.broadcast();
  Stream<Map> get stream => _ctrl.stream;

  QueueSocketClient(this.baseUrl);

  void connect(String shopId) {
    _ch = WebSocketChannel.connect(Uri.parse('$baseUrl/queue?shopId=$shopId'));
    _ch!.stream.listen((m) => _ctrl.add({'raw': m}), onDone: () {
      Future.delayed(const Duration(seconds: 5), () => connect(shopId)); // reconnect + polling fallback di repo
    });
  }
  void dispose() { _ch?.sink.close(); _ctrl.close(); }
}
