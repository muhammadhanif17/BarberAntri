import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/domain/entities/auth_session.dart';
import 'features/discovery/presentation/pages/home_page.dart';
import 'features/discovery/domain/shop_models.dart';
import 'features/barbershop_detail/presentation/pages/shop_detail_page.dart';
import 'features/queue_booking/presentation/pages/eticket_page.dart';
import 'features/queue_booking/data/queue_repository.dart';
import 'features/partner_dashboard/presentation/pages/partner_shell.dart';

/// Router: login(role) -> home B2C (detail -> e-tiket) | PartnerShell B2B (Layar 01-06).
class BarberAntriApp extends StatefulWidget {
  const BarberAntriApp({super.key});
  @override State<BarberAntriApp> createState() => _BarberAntriAppState();
}

class _BarberAntriAppState extends State<BarberAntriApp> {
  AuthSession? session;
  late final api = ApiClient();
  late final queues = QueueRepository(api);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BarberAntri',
    theme: buildAppTheme(),
    home: session == null
      ? LoginPage(onLoggedIn: (s) => setState(() => session = s))
      : session!.role == UserRole.mitra
        ? const PartnerShell()
        : HomePage(
            userName: session!.name,
            onShopTap: (shop) => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ShopDetailPage(
                shop: shop,
                onTakeQueue: () => queues.takeQueueMock(shopName: shop.name),
                onTicketCreated: (t) => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ETicketPage(ticket: t))),
              ))),
          ),
  );
}
