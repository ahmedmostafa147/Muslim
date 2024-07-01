import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'style.dart';

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
  primaryColor: Colors.teal,
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Colors.teal,
    secondary: Colors.teal,
    surface: Color(0xFF212121),
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
      iconColor: WidgetStateProperty.all<Color>(Colors.teal),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    ),
  ),
  fontFamily: TextFontType.cairoFont,
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: Colors.blueGrey[900],
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: TextFontType.cairoFont),
  ),
);
