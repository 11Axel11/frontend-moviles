import 'package:flutter/material.dart';
import 'package:frontend_moviles/modules/reservas/widgets/notificaciones_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const TableNowApp());
}
