
// lib/src/models/odoo_session.dart
class OdooSession {
  final String baseUrl;
  final String database;
  final String username;
  final String password;
  final int userId;
  final Map<String, dynamic> context;

  OdooSession({
    required this.baseUrl,
    required this.database,
    required this.username,
    required this.password,
    required this.userId,
    required this.context,
  });
}
