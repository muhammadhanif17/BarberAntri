import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/entities/auth_session.dart';

/// Mockup Login: toggle Masuk/Daftar Pelanggan vs Mitra, field No HP + sandi,
/// tombol Google + WhatsApp. Role menentukan rute: /home (B2C) vs /partner (B2B).
class LoginPage extends StatefulWidget {
  final void Function(AuthSession session) onLoggedIn;
  const LoginPage({super.key, required this.onLoggedIn});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserRole role = UserRole.pelanggan;
  final phone = TextEditingController(text: '0812-8599-7721');
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Selamat Datang di BarberAntri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      SegmentedButton<UserRole>(
        segments: const [
          ButtonSegment(value: UserRole.pelanggan, label: Text('Pelanggan')),
          ButtonSegment(value: UserRole.mitra, label: Text('Mitra')),
        ],
        selected: {role},
        onSelectionChanged: (s) => setState(() => role = s.first),
      ),
      const SizedBox(height: 12),
      TextField(controller: phone, decoration: const InputDecoration(labelText: 'Nomor WhatsApp', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'Kata Sandi', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: () => widget.onLoggedIn(AuthSession(
          token: 'mock-jwt', role: role,
          name: role == UserRole.pelanggan ? 'Gabriel' : 'Vintage Cut Studio')),
        child: const Text('Masuk / Selengkapnya →'),
      ),
      const SizedBox(height: 12),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Chip(label: Text('Google')), SizedBox(width: 8), Chip(label: Text('WhatsApp', style: TextStyle(color: AppColors.mintDark))),
      ]),
    ])),
  );
}
