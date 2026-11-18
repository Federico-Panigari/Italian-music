import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import '/screens/splash_screen.dart';
import '/screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/account_service.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  final AccountService accountService = AccountService();

  void changeTheme(ThemeMode newThemeMode) {
  setState(() {
    themeMode = newThemeMode;
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITALIA MUSIC',
      debugShowCheckedModeBanner: false,

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      routes: {
        '/login': (context) => LoginScreen(
          accountService: accountService,
        ),

        '/home': (context) => HomeScreen(
          onThemeChanged: changeTheme,
          currentEmail: ModalRoute.of(context)!.settings.arguments as String,
          accountService: accountService,
        ),
      },

      home: const SplashScreen(),
    );
  }
}

