/// Endpoint terpusat. Gateway -> queue-engine :3003 (lihat docker-compose).
class ApiEndpoints {
  static const gateway = 'http://10.0.2.2:8080';
  static const queueWs = 'ws://10.0.2.2:3003';
  static const takeQueue = '/queue/take';
  static const walkin = '/queue/walkin';
  static String shopQueue(String shopId) => '/queue/$shopId';
  static String position(String shopId, String ticketId) => '/queue/position/$shopId/$ticketId';
  static String action(String ticketId, String act) => '/queue/$ticketId/$act'; // call|start|finish|cancel
}

class AppConstants {
  static const avgDurationMin = 15;
  static const remindThreshold = 3; // H-2~H-3 sesuai PDF + mockup
}
