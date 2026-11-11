import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6140C7),
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF6140C7),
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6140C7),
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFF6140C7),
  ),
  useMaterial3: true,
);