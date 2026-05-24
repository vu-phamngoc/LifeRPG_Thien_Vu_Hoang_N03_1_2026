import 'package:flutter/material.dart';
import 'screens/shared/splash_screen.dart';

class LifeRPGApp extends StatelessWidget {
  const LifeRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life RPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const SplashScreen(),
    );
  }
}
