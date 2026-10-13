enum UserRole { pelanggan, mitra }

class AuthSession {
  final String token;
  final UserRole role;
  final String name;
  const AuthSession({required this.token, required this.role, required this.name});
}
