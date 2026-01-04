import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Colors
class ColorsStyleApp {
  static const Color lightBackground = Color(0xFFEADAB7);
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color gold = Color(0xFFD4AF37);
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF0A4D68),
  scaffoldBackgroundColor: const Color(0xFFEADAB7),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0A4D68),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  cardColor: Colors.white,
  iconTheme: const IconThemeData(color: Color(0xFF0A4D68)),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFD4AF37),
  scaffoldBackgroundColor: const Color(0xFF1C1C1C),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2C2C2C),
    foregroundColor: Color(0xFFD4AF37),
    centerTitle: true,
  ),
  cardColor: const Color(0xFF2C2C2C),
  iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
);

// Text Font Types
class TextFontType {
  static const String quranFont = 'Amiri';
  static const String cairoFont = 'Cairo';
  static const String arefRuqaaFont = 'Aref Ruqaa';
  static const String notoNastaliqUrduFont = 'Noto Nastaliq Urdu';
}
