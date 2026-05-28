import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'modules/splash/screens/splash_screen.dart';

class TableNowApp extends StatelessWidget {
  const TableNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}