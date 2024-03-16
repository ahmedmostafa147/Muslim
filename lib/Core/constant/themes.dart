import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_style.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.teal,
  colorScheme: const ColorScheme.light(
    primary: Colors.teal,
    secondary: Colors.teal,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(Colors.teal),
    trackColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 255, 255, 255)),
    trackOutlineColor: MaterialStateProperty.all<Color>(Colors.teal),
  ),
  iconTheme: const IconThemeData(color: Colors.teal),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.teal),
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.teal,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.teal,
    thickness: 1.5,
  ),
  fontFamily: TextFontStyle.cairoFont,
  useMaterial3: true,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  primaryColor: const Color(0XFFD4A331),
  colorScheme: const ColorScheme.dark(
    primary: Color(0XFFD4A331),
    secondary: Color(0XFFD4A331),
    surface: Colors.black,
    background: Colors.black,
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(Colors.amber),
    trackColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.amber),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.amber),
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0XFFD4A331),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0XFFD4A331),
    thickness: 1.0,
  ),
  fontFamily: TextFontStyle.cairoFont,
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0),
);
