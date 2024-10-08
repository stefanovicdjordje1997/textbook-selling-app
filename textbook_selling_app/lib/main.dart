import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/theme/theme.dart';
import 'package:textbook_selling_app/features/auth/view/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme, // Koristi svetlu temu
      darkTheme: AppTheme.darkTheme, // Koristi tamnu temu
      themeMode:
          ThemeMode.system, // Automatski menja temu prema sistemskoj temi
      home: const Scaffold(body: LoginScreen()),
    );
  }
}
