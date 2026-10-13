import '../../../core/network/api_client.dart';
import '../../../core/config/api_endpoints.dart';
import '../domain/partner_models.dart';

/// Bridge B2B -> queue-engine yang sudah jadi (3/3 test pass).
/// One-tap: call -> start -> finish | cancel. Walk-in via INCR atomik yang sama.
class PartnerQueueRepository {
  final ApiClient api;
  PartnerQueueRepository(this.api);

  Future<List<PartnerTicket>> fetchQueue(String shopId) async {
    try {
      final res = await api.get(ApiEndpoints.shopQueue(shopId));
      final list = (res['waiting'] as List? ?? []);
      return list.map((h) => PartnerTicket(
        id: h['id'] as String, code: h['code'] as String,
        customer: (h['customerName'] as String?) ?? 'Tamu',
        phone: (h['phone'] as String?) ?? '',
        service: (h['serviceId'] as String?) ?? '-',
        price: 50000, kapster: (h['kapsterId'] as String?) ?? '-',
        isWalkIn: h['source'] == 'WALKIN',
      )).toList();
    } catch (_) {
      return mockPartnerQueue; // fallback mockup agar UI tetap jalan
    }
  }

  Future<void> oneTap(String ticketId, String act) async {
    // act: call | start | finish | cancel
    try {
      await api.post(ApiEndpoints.action(ticketId, act), {});
    } catch (_) {/* mode mockup: abaikan */}
  }

  Future<PartnerTicket> addWalkIn({required String shopId, required String name,
    required String phone, String service = 'Low Fade Cut', String kapster = 'Rian'}) async {
    try {
      final res = await api.post(ApiEndpoints.walkin,
        {'shopId': shopId, 'customerName': name, 'phone': phone});
      final t = res['ticket'] as Map<String, dynamic>;
      return PartnerTicket(id: t['id'] as String, code: t['code'] as String,
        customer: name, phone: phone, service: service, price: 50000,
        kapster: kapster, isWalkIn: true);
    } catch (_) {
      return PartnerTicket(id: 'q-mock', code: 'A-09', customer: name,
        phone: phone, service: service, price: 50000, kapster: kapster, isWalkIn: true);
    }
  }
}
