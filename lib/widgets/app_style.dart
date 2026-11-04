import 'package:flutter/material.dart';

abstract final class AppStyle {
  static const navy = Color(0xFF3C4E69);
  static const blue = Color(0xFF6C83A4);
  static const yellow = Color(0xFFF3B43F);
  static ThemeData theme(ThemeData base) => base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: navy,
        disabledForegroundColor: Colors.white70,
        minimumSize: const Size(64, 64),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
