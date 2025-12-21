
// lib/src/screens/partners_screen.dart
import 'package:flutter/material.dart';
import '../services/odoo_service.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  List<dynamic>? _partners;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final partners = await OdooService.instance.searchRead(
        model: 'res.partner',
        domain: [],
        fields: ['id', 'name', 'email', 'phone', 'is_company'],
        limit: 100,
      );

      setState(() {
        _partners = partners;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPartners,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_partners == null || _partners!.isEmpty) {
      return const Center(child: Text('No hay partners'));
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
                backgroundColor: isCompany ? Colors.blue.shade100 : Colors.green.shade100,
                child: Icon(
                  isCompany ? Icons.business : Icons.person,
                  color: isCompany ? Colors.blue : Colors.green,
                ),
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
