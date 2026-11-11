import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import '/screens/splash_screen.dart';
import '/screens/login_screen.dart';
import 'screens/home_screen.dart';

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

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },

      home: const SplashScreen(),
    );
  }
}

