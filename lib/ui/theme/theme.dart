import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(136, 14, 79, 1);
const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

final theme = ThemeData(
  primaryColor: primaryColor,
  primaryColorDark: primaryColorDark,
  primaryColorLight: primaryColorLight,
  splashColor: primaryColorLight,
  highlightColor: primaryColorLight,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: primaryColorDark,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
  ),
);
