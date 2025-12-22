// lib/src/services/sync_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../repositories/clientes_repository.dart';
import 'odoo_service.dart';

/// Servicio de sincronización automática en segundo plano
/// Implementa el patrón offline-first con sincronización bidireccional
class SyncService {
  static final SyncService instance = SyncService._internal();
  factory SyncService() => instance;
  SyncService._internal();

  Timer? _syncTimer;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  // Notificadores para la UI
  final ValueNotifier<bool> isSyncingNotifier = ValueNotifier(false);
  final ValueNotifier<String?> lastSyncStatus = ValueNotifier(null);
  final ValueNotifier<DateTime?> lastSyncTimeNotifier = ValueNotifier(null);

  late ClientesRepository _clientesRepository;
  bool _isInitialized = false;

  /// Inicializar el servicio de sincronización
  void initialize(AppDatabase db, OdooService odooService) {
    if (_isInitialized) return;
    
    _clientesRepository = ClientesRepository(db, odooService);
    _isInitialized = true;
    
    debugPrint('✅ SyncService inicializado');
  }

  /// Iniciar sincronización automática periódica
  /// [interval] - intervalo entre sincronizaciones (default: 5 minutos)
  void startAutoSync({Duration interval = const Duration(minutes: 5)}) {
    if (!_isInitialized) {
      debugPrint('❌ SyncService no inicializado');
      return;
    }

    stopAutoSync(); // Detener cualquier timer previo

    _syncTimer = Timer.periodic(interval, (_) {
      if (!_isSyncing && OdooService.instance.isAuthenticated) {
        syncAll();
      }
    });

    debugPrint('🔄 Sincronización automática iniciada (cada ${interval.inMinutes} min)');
  }

  /// Detener sincronización automática
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('⏸️ Sincronización automática detenida');
  }

  /// Ejecutar sincronización completa (bidireccional)
  /// 1. Sincroniza cambios locales hacia Odoo (push)
  /// 2. Sincroniza datos de Odoo hacia local (pull)
  Future<SyncSummary> syncAll({bool showProgress = false}) async {
    if (_isSyncing) {
      debugPrint('⚠️ Ya hay una sincronización en progreso');
      return SyncSummary(
        success: false,
        message: 'Sincronización ya en progreso',
      );
    }

    if (!OdooService.instance.isAuthenticated) {
      debugPrint('⚠️ No hay sesión activa con Odoo');
      return SyncSummary(
        success: false,
        message: 'No hay conexión con Odoo',
      );
    }

    _isSyncing = true;
    isSyncingNotifier.value = true;
    
    final summary = SyncSummary(success: true);

    try {
      debugPrint('🔄 Iniciando sincronización completa...');

      // PASO 1: Push - Sincronizar cambios locales hacia Odoo
      if (showProgress) lastSyncStatus.value = 'Enviando cambios locales...';
      
      final pushResult = await _clientesRepository.syncToOdoo();
      summary.clientesPushed = pushResult.inserted + pushResult.updated;
      summary.pushErrors = pushResult.errors;
      
      debugPrint('📤 Push completado: ${summary.clientesPushed} enviados, ${summary.pushErrors} errores');

      // PASO 2: Pull - Sincronizar datos de Odoo hacia local
      if (showProgress) lastSyncStatus.value = 'Recibiendo datos de Odoo...';
      
      final pullResult = await _clientesRepository.syncFromOdoo(limit: 500);
      summary.clientesPulled = pullResult.inserted + pullResult.updated;
      summary.pullErrors = pullResult.errors;
      
      debugPrint('📥 Pull completado: ${summary.clientesPulled} recibidos, ${summary.pullErrors} errores');

      // Actualizar estado
      _lastSyncTime = DateTime.now();
      lastSyncTimeNotifier.value = _lastSyncTime;
      
      final totalErrors = summary.pushErrors + summary.pullErrors;
      summary.message = totalErrors > 0
          ? 'Sincronizado con $totalErrors errores'
          : 'Sincronización exitosa';
      
      lastSyncStatus.value = summary.message;
      
      debugPrint('✅ Sincronización completa: ${summary.message}');

      return summary;
    } catch (e) {
      debugPrint('❌ Error en sincronización: $e');
      
      summary.success = false;
      summary.message = 'Error: ${e.toString()}';
      lastSyncStatus.value = summary.message;
      
      return summary;
    } finally {
      _isSyncing = false;
      isSyncingNotifier.value = false;
    }
  }

  /// Sincronizar solo desde Odoo (pull)
  Future<SyncSummary> pullFromOdoo() async {
    if (!_isInitialized || !OdooService.instance.isAuthenticated) {
      return SyncSummary(
        success: false,
        message: 'No disponible',
      );
    }

    try {
      isSyncingNotifier.value = true;
      lastSyncStatus.value = 'Descargando clientes...';

      final result = await _clientesRepository.syncFromOdoo(limit: 500);
      
      final summary = SyncSummary(
        success: result.success,
        clientesPulled: result.inserted + result.updated,
        pullErrors: result.errors,
        message: result.success 
            ? 'Descargados ${result.inserted + result.updated} clientes'
            : result.error ?? 'Error desconocido',
      );

      lastSyncStatus.value = summary.message;
      lastSyncTimeNotifier.value = DateTime.now();

      return summary;
    } finally {
      isSyncingNotifier.value = false;
    }
  }

  /// Sincronizar solo hacia Odoo (push)
  Future<SyncSummary> pushToOdoo() async {
    if (!_isInitialized || !OdooService.instance.isAuthenticated) {
      return SyncSummary(
        success: false,
        message: 'No disponible',
      );
    }

    try {
      isSyncingNotifier.value = true;
      lastSyncStatus.value = 'Enviando cambios...';

      final result = await _clientesRepository.syncToOdoo();
      
      final summary = SyncSummary(
        success: result.success,
        clientesPushed: result.inserted + result.updated,
        pushErrors: result.errors,
        message: result.success 
            ? 'Enviados ${result.inserted + result.updated} cambios'
            : result.error ?? 'Error desconocido',
      );

      lastSyncStatus.value = summary.message;

      return summary;
    } finally {
      isSyncingNotifier.value = false;
    }
  }

  /// Verificar si hay cambios pendientes
  Future<int> getPendingChangesCount() async {
    if (!_isInitialized) return 0;
    
    final pendientes = await _clientesRepository.getClientesPendientes();
    return pendientes.length;
  }

  // Getters
  bool get isSyncing => _isSyncing;
  bool get isAutoSyncActive => _syncTimer?.isActive ?? false;
  DateTime? get lastSyncTime => _lastSyncTime;
  
  /// Limpiar recursos
  void dispose() {
    stopAutoSync();
    isSyncingNotifier.dispose();
    lastSyncStatus.dispose();
    lastSyncTimeNotifier.dispose();
  }
}

// ==================== MODELOS ====================

class SyncSummary {
  bool success;
  String message;
  int clientesPushed;
  int clientesPulled;
  int pushErrors;
  int pullErrors;

  SyncSummary({
    required this.success,
    this.message = '',
    this.clientesPushed = 0,
    this.clientesPulled = 0,
    this.pushErrors = 0,
    this.pullErrors = 0,
  });

  int get totalSynced => clientesPushed + clientesPulled;
  int get totalErrors => pushErrors + pullErrors;
  bool get hasErrors => totalErrors > 0;

  @override
  String toString() => message;
}