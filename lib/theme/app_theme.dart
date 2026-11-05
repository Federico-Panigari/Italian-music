import 'package:flutter/material.dart';

final ThemeData temaChiaro = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor:  const Color(0xFF6140C7),
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF6140C7),
  ),
  useMaterial3: true,
);

final ThemeData temaScuro = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor:  const Color(0xFF6140C7),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);