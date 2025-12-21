
// lib/main.dart
import 'package:flutter/material.dart';
import 'src/services/preferences_service.dart';
import 'src/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const MyApp());
}
