
// lib/src/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/odoo_service.dart';
import '../services/preferences_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = OdooService.instance.session;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Información de Conexión',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const Divider(),
                _buildInfoRow('Servidor', session?.baseUrl ?? 'N/A'),
                _buildInfoRow('Base de datos', session?.database ?? 'N/A'),
                _buildInfoRow('Usuario', session?.username ?? 'N/A'),
                _buildInfoRow('User ID', session?.userId.toString() ?? 'N/A'),
                _buildInfoRow(
                  'Estado',
                  OdooService.instance.isAuthenticated ? '✅ Conectado' : '❌ Desconectado',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Cambiar Credenciales'),
            subtitle: const Text('Modificar datos de conexión'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await PreferencesService.clearCredentials();
              OdooService.instance.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
