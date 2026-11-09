import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import '/screens/splash_screen.dart';
import '/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITALIA MUSIC',
      debugShowCheckedModeBanner: false,

      theme: temaChiaro,
      darkTheme: temaScuro,
      themeMode: ThemeMode.light,

      routes: {
        '/login': (context) => const LoginScreen(),
      },

      home: const SplashScreen(),
    );
  }
}

