import 'package:flutter/material.dart';
import 'package:bio_calc/theme/app_theme.dart';
import 'package:bio_calc/screens/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bio-Calc Suite',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const AppShell(),
    );
  }
}
