
// lib/src/services/odoo_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/odoo_session.dart';
import 'preferences_service.dart';

class OdooService {
  static final OdooService instance = OdooService._internal();
  factory OdooService() => instance;
  OdooService._internal();

  OdooSession? _session;
  String _baseUrl = 'https://tumburu.es';

  OdooSession? get session => _session;
  bool get isAuthenticated => _session != null;
  String get baseUrl => _baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  Future<OdooSession> authenticate(String db, String login, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/web/session/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {'db': db, 'login': login, 'password': password},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['error'] != null) {
      throw Exception(data['error']['data']['message']);
    }

    final result = data['result'];
    
    if (result == null || result['uid'] == null || result['uid'] == false) {
      throw Exception('Credenciales incorrectas');
    }

    _session = OdooSession(
      baseUrl: _baseUrl,
      database: db,
      username: login,
      password: password,
      userId: result['uid'],
      context: result['user_context'] ?? {},
    );

    // Guardar credenciales
    await PreferencesService.saveCredentials(
      baseUrl: _baseUrl,
      database: db,
      username: login,
      password: password,
    );

    return _session!;
  }

  Future<dynamic> _rpcCall(String endpoint, Map<String, dynamic> params) async {
    if (_session == null) throw Exception('No hay sesión activa');

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jsonrpc': '2.0', 'method': 'call', 'params': params}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['error'] != null) {
      throw Exception(data['error']['data']['message']);
    }

    return data['result'];
  }

  Future<dynamic> executeKw(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic>? kwargs,
  ]) async {
    return await _rpcCall('/jsonrpc', {
      'service': 'object',
      'method': 'execute_kw',
      'args': [
        _session!.database,
        _session!.userId,
        _session!.password,
        model,
        method,
        args,
        kwargs ?? {},
      ],
    });
  }

  Future<List<dynamic>> searchRead({
    required String model,
    List<dynamic>? domain,
    List<String>? fields,
    int? limit,
    int? offset,
  }) async {
    final kwargs = <String, dynamic>{
      'domain': domain ?? [],
      'fields': fields ?? [],
    };
    
    if (limit != null) kwargs['limit'] = limit;
    if (offset != null) kwargs['offset'] = offset;

    final result = await executeKw(model, 'search_read', [], kwargs);
    return result as List<dynamic>;
  }

  void logout() {
    _session = null;
  }
}
