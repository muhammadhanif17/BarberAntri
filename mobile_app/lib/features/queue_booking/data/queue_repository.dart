import '../../discovery/domain/shop_models.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_endpoints.dart';

/// Jembatan Flutter -> queue-engine (backend yang sudah jadi + teruji).
/// POST /queue/take {shopId, kapsterId} -> {ticket, position, etaMin, reminder}
class QueueRepository {
  final ApiClient api;
  QueueRepository(this.api);

  Future<Ticket> takeQueue({required String shopId, String? kapsterId, String shopName = ''}) async {
    final res = await api.post(ApiEndpoints.takeQueue,
      {'shopId': shopId, if (kapsterId != null) 'kapsterId': kapsterId});
    final t = res['ticket'] as Map<String, dynamic>;
    return Ticket(code: t['code'] as String, shopName: shopName,
      position: (res['position'] as num?)?.toInt() ?? 0,
      etaMin: (res['etaMin'] as num?)?.toInt() ?? AppConstants.avgDurationMin);
  }

  /// Demo tanpa backend (mockup A-07): dipakai agar UI bisa diklik di Stitch/review.
  Future<Ticket> takeQueueMock({String shopName = 'Barbershop Vintage Cut'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Ticket(code: 'A-07', shopName: 'Barbershop Vintage Cut', position: 4, etaMin: 15);
  }
}
