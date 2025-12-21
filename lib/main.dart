import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// Clase para manejar la sesión de Odoo
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

// Cliente para Odoo usando autenticación básica en cada petición
class OdooClient {
  final String baseUrl;
  OdooSession? _session;

  OdooClient(this.baseUrl);

  OdooSession? get session => _session;

  // Autenticar en Odoo - solo valida credenciales y guarda info
  Future<OdooSession> authenticate(String db, String login, String password) async {
    print('🔐 Validando credenciales en: $baseUrl/web/session/authenticate');
    
    final response = await http.post(
      Uri.parse('$baseUrl/web/session/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'db': db,
          'login': login,
          'password': password,
        },
      }),
    );

    print('📡 Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['error'] != null) {
      throw Exception('Error de Odoo: ${data['error']['data']['message']}');
    }

    final result = data['result'];
    
    if (result == null || result['uid'] == null || result['uid'] == false) {
      throw Exception('Credenciales incorrectas');
    }

    print('✅ Autenticación exitosa!');
    print('✅ User ID: ${result['uid']}');
    print('✅ User: ${result['name']}');
    print('✅ Database: $db');

    // Guardamos las credenciales para re-autenticar en cada llamada
    _session = OdooSession(
      baseUrl: baseUrl,
      database: db,
      username: login,
      password: password,
      userId: result['uid'],
      context: result['user_context'] ?? {},
    );

    return _session!;
  }

  // Ejecutar llamada RPC - autenticándose en cada petición
  Future<dynamic> _rpcCall(String endpoint, Map<String, dynamic> params) async {
    if (_session == null) {
      throw Exception('No hay sesión activa. Inicia sesión primero.');
    }

    print('📞 Llamando a: $endpoint');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': params,
      }),
    );

    print('📡 Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Error HTTP: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['error'] != null) {
      final error = data['error'];
      print('❌ Error de Odoo: ${error['data']['message']}');
      throw Exception('Error: ${error['data']['message']}');
    }

    return data['result'];
  }

  // Método para llamar funciones de modelos usando XML-RPC style
  Future<dynamic> execute(String model, String method, List<dynamic> args) async {
    if (_session == null) {
      throw Exception('No hay sesión activa');
    }

    print('📞 Ejecutando: $model.$method');
    
    // Usamos el endpoint común que funciona sin cookies
    final result = await _rpcCall('/jsonrpc', {
      'service': 'object',
      'method': 'execute',
      'args': [
        _session!.database,
        _session!.userId,
        _session!.password,
        model,
        method,
        ...args,
      ],
    });

    return result;
  }

  // Método mejorado con kwargs
  Future<dynamic> executeKw(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic>? kwargs,
  ]) async {
    if (_session == null) {
      throw Exception('No hay sesión activa');
    }

    print('📞 Ejecutando (kw): $model.$method');
    
    final result = await _rpcCall('/jsonrpc', {
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

    return result;
  }

  // Buscar y leer registros
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

  // Cerrar sesión
  void logout() {
    _session = null;
    print('🔓 Sesión cerrada');
  }
}

// Instancia global del cliente
final odooClient = OdooClient('https://tumburu.es');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _dbController = TextEditingController(text: 'betat1');
  final _emailController = TextEditingController(text: 'duvalsoft@gmail.com');
  final _passwordController = TextEditingController(text: 'Odisea2001');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final session = await odooClient.authenticate(
        _dbController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      print('✅ Navegando a HomePage...');
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(session: session),
        ),
      );
      
    } catch (e) {
      print('❌ Error en login: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Odoo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _dbController,
                  decoration: const InputDecoration(
                    labelText: 'Database',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storage),
                  ),
                  validator: (val) => val!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (val) => val!.isEmpty ? 'Requerido' : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Iniciar Sesión',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dbController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  final OdooSession session;
  
  const HomePage({super.key, required this.session});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _partners;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('🏠 HomePage iniciada');
    print('🏠 User ID: ${widget.session.userId}');
    print('🏠 Database: ${widget.session.database}');
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('📞 Cargando partners...');
      
      final partners = await odooClient.searchRead(
        model: 'res.partner',
        domain: [],
        fields: ['id', 'name', 'email', 'phone', 'is_company'],
        limit: 50,
      );

      print('✅ ${partners.length} partners cargados');

      setState(() {
        _partners = partners;
        _isLoading = false;
      });
      
    } catch (e) {
      print('❌ Error cargando partners: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      odooClient.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadPartners,
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando partners...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadPartners,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_partners == null || _partners!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay partners disponibles'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPartners,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _partners!.length,
        itemBuilder: (context, index) {
          final partner = _partners![index] as Map<String, dynamic>;
          final name = partner['name'] as String? ?? 'Sin nombre';
          final email = partner['email'];
          final phone = partner['phone'];
          final isCompany = partner['is_company'] as bool? ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isCompany 
                    ? Colors.blue.shade100 
                    : Colors.green.shade100,
                child: Icon(
                  isCompany ? Icons.business : Icons.person,
                  color: isCompany ? Colors.blue : Colors.green,
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${partner['id']}'),
                  if (email != null && email != false)
                    Text('📧 $email', style: const TextStyle(fontSize: 12)),
                  if (phone != null && phone != false)
                    Text('📱 $phone', style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: Icon(
                isCompany ? Icons.business : Icons.person_outline,
                color: Colors.grey,
              ),
              isThreeLine: (email != null && email != false) || 
                           (phone != null && phone != false),
            ),
          );
        },
      ),
    );
  }
}