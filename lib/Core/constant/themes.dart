import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim/Core/constant/style.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  splashColor: Colors.white,
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
    trackColor: MaterialStateProperty.all<Color>(Colors.white),
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
  fontFamily: TextFontType.cairoFont,
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
  scaffoldBackgroundColor: const Color.fromARGB(186, 52, 55, 78),
  splashColor: const Color.fromARGB(186, 52, 55, 78),
  primaryColor: const Color(0XFFD4A331),
  colorScheme: const ColorScheme.dark(
    primary: Color(0XFFD4A331),
    secondary: Color(0XFFD4A331),
    surface: Colors.black,
    background: Color.fromRGBO(32, 33, 37, 255),
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  cardTheme: const CardTheme(
    color: Color.fromARGB(186, 52, 55, 78),
    elevation: 2,
    shadowColor: Color.fromARGB(186, 52, 55, 78),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(Colors.amber),
    trackColor: MaterialStateProperty.all<Color>(Colors.white),
    trackOutlineColor: MaterialStateProperty.all<Color>(Colors.amber),
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
    thickness: 1.5,
  ),
  fontFamily: TextFontType.cairoFont,
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
