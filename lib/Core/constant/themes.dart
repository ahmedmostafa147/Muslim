import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFontType {
  static const String quranFont = 'Quran';
  static const String quran2Font = 'Quran2';
  static const String cairoFont = 'Cairo';
  static const String arefRuqaaFont = 'ArefRuqaa';
  static const String notoNastaliqUrduFont = 'NotoNastaliqUrdu';
}

class TextFontSize {}

class ColorsStyleApp {
  static const lightPrimary = Color(0xFF0F969C); // Teal color
  static const darkPrimary =
      Color(0xFF0F969C); // Teal color (kept same for consistency)

  static const lightAccent = Color(0xFFAED9E0); // Light teal color
  static const darkAccent =
      Color(0xFF8FD3DF); // Light teal color (kept same for consistency)

  static const white = Colors.white;
  static const black =
      Color(0xFF1F1F1F); // Slightly lighter black for readability

  static const hoverDark = Color(0xFF6DAC50); // A gentle green for dark hover
  static const hoverLight = Color(0xFF0F969C); // Teal color for light hover

  static const lightBackground = Color(0xFFFFFBF5); // Light beige color
  static const darkBackground = Color(0xFF05161A); // Dark background color
}

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFFFFBF5), // Light beige color
  splashColor: const Color(0xFFAED9E0), // Light teal accent
  primaryColor: const Color(0xFF0F969C), // Teal color
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0F969C), // Teal color
    secondary: Color(0xFFAED9E0), // Light teal color
    surface: Colors.white, // White color
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  cardTheme: const CardTheme(
    color: Colors.white, // White color
    elevation: 2,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.all<Color>(const Color(0xFF0F969C)), // Teal color
    trackColor: WidgetStateProperty.all<Color>(
        const Color(0xFFAED9E0)), // Light teal color
    trackOutlineColor:
        WidgetStateProperty.all<Color>(const Color(0xFF0F969C)), // Teal color
  ),
  iconTheme: const IconThemeData(color: Color(0xFF0F969C)), // Teal color
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          WidgetStateProperty.all<Color>(const Color(0xFF0F969C)), // Teal color
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF0F969C), // Teal color
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF0F969C), // Teal color
    thickness: 1.5,
  ),
  fontFamily: TextFontType.cairoFont,
  useMaterial3: true,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: const Color(0xFFFFFBF5),
    iconTheme: const IconThemeData(color: Color(0xFF0F969C)),
    titleSpacing: 0.0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFBF5),
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: const Color(0xFF0F969C),
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      fontFamily: TextFontType.cairoFont,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xFF0F969C),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color(0xFF0F969C),
    secondary: Color(0xFF0F969C),
    surface: Color(0xFF05161A),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
  dividerTheme: const DividerThemeData(thickness: 1.0),
  iconTheme: const IconThemeData(color: Colors.white),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all<Color>(const Color(0xFF0F969C)),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    ),
  ),
  fontFamily: TextFontType.cairoFont,
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: const Color(0xFF0F969C),
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      fontFamily: TextFontType.cairoFont,
    ),
  ),
);
