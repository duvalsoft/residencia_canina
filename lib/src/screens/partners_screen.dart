// lib/src/screens/partners_screen.dart
import 'package:flutter/material.dart';
import '../data/database.dart';
import '../services/sync_service.dart';
import '../services/odoo_service.dart';
import '../repositories/clientes_repository.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  late final AppDatabase _db;
  late final ClientesRepository _repository;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _repository = ClientesRepository(_db, OdooService.instance);
    
    // Inicializar SyncService
    SyncService.instance.initialize(_db, OdooService.instance);
    
    // Sincronización inicial
    _syncInicial();
  }

  Future<void> _syncInicial() async {
    // Hacer una sincronización inicial si hay conexión
    if (OdooService.instance.isAuthenticated) {
      await SyncService.instance.pullFromOdoo();
    }
  }

  Future<void> _manualSync() async {
    final result = await SyncService.instance.syncAll(showProgress: true);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success 
            ? (result.hasErrors ? Colors.orange : Colors.green)
            : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra de búsqueda y sincronización
          _buildSearchBar(),
          
          // Indicador de sincronización
          _buildSyncIndicator(),
          
          // Lista de clientes
          Expanded(
            child: _buildClientesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClienteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar clientes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: SyncService.instance.isSyncingNotifier,
            builder: (context, isSyncing, _) {
              return IconButton(
                icon: isSyncing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                onPressed: isSyncing ? null : _manualSync,
                tooltip: 'Sincronizar',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncIndicator() {
    return ValueListenableBuilder<String?>(
      valueListenable: SyncService.instance.lastSyncStatus,
      builder: (context, status, _) {
        if (status == null) return const SizedBox.shrink();
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status,
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ),
              ValueListenableBuilder<DateTime?>(
                valueListenable: SyncService.instance.lastSyncTimeNotifier,
                builder: (context, lastSync, _) {
                  if (lastSync == null) return const SizedBox.shrink();
                  
                  final diff = DateTime.now().difference(lastSync);
                  String timeAgo;
                  
                  if (diff.inMinutes < 1) {
                    timeAgo = 'Ahora';
                  } else if (diff.inHours < 1) {
                    timeAgo = 'Hace ${diff.inMinutes} min';
                  } else {
                    timeAgo = 'Hace ${diff.inHours} h';
                  }
                  
                  return Text(
                    timeAgo,
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade600),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClientesList() {
    return StreamBuilder<List<ClienteDb>>(
      stream: _repository.watchAllClientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        var clientes = snapshot.data ?? [];

        // Filtrar por búsqueda si hay query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          clientes = clientes.where((c) {
            return c.name.toLowerCase().contains(query) ||
                (c.email?.toLowerCase().contains(query) ?? false);
          }).toList();
        }

        if (clientes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No hay clientes\nPulsa + para agregar'
                      : 'No se encontraron resultados',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            final cliente = clientes[index];
            return _buildClienteItem(cliente);
          },
        );
      },
    );
  }

  Widget _buildClienteItem(ClienteDb cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cliente.isSynced
              ? Colors.green.shade100
              : Colors.orange.shade100,
          child: Text(
            cliente.name.isNotEmpty ? cliente.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: cliente.isSynced
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(cliente.name)),
            if (!cliente.isSynced)
              const Icon(Icons.cloud_off, size: 16, color: Colors.orange),
            if (cliente.hasPendingChanges)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.edit, size: 16, color: Colors.blue),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cliente.email != null) Text(cliente.email!),
            if (cliente.phone != null || cliente.mobile != null)
              Text(cliente.phone ?? cliente.mobile ?? ''),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditClienteDialog(cliente);
                break;
              case 'delete':
                _deleteCliente(cliente);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddClienteDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Cliente'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre*',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val?.isEmpty ?? true ? 'Nombre requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await _repository.createCliente(
                  name: nameController.text,
                  email: emailController.text.isEmpty
                      ? null
                      : emailController.text,
                  phone: phoneController.text.isEmpty
                      ? null
                      : phoneController.text,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cliente creado (pendiente sincronización)'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditClienteDialog(ClienteDb cliente) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: cliente.name);
    final emailController = TextEditingController(text: cliente.email ?? '');
    final phoneController = TextEditingController(text: cliente.phone ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Cliente'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre*',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val?.isEmpty ?? true ? 'Nombre requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await _repository.updateCliente(
                  cliente.id,
                  name: nameController.text,
                  email: emailController.text.isEmpty
                      ? null
                      : emailController.text,
                  phone: phoneController.text.isEmpty
                      ? null
                      : phoneController.text,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cliente actualizado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCliente(ClienteDb cliente) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar a ${cliente.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _repository.deleteCliente(cliente.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente eliminado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _db.close();
    super.dispose();
  }
}