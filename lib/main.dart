import 'package:flutter/material.dart';
import 'theme/zalyx_theme.dart';
import 'screens/hydration_studio_screen.dart';

void main() {
  runApp(const ZalyxApp());
}

class ZalyxApp extends StatelessWidget {
  const ZalyxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zalyx Hydration',
      debugShowCheckedModeBanner: false,
      theme: ZalyxTheme.themeData,
      home: const HydrationStudioScreen(),
    );
  }
}
