import 'package:flutter/material.dart';
import 'package:muslim/View/Quran/screen/surah_name_p.dart';
import 'View/salah/home_salah.dart';
import 'View/home/Drawer/drawer.dart';
import 'View/Splash Screen/splash_screen.dart';
import 'View/home/home.dart';
import 'widgets/nav_bar_widget.dart';

class AppRoute {
  static const String splash = "/splash";
  static const String home = "/home";
  static const String bottomNaveBar = "/bottomNaveBar";
  static const String salah = "/PrayerTimesScreen";
  static const String quran = "/quran";
  static const String drawer = "/drawer";
  static const String prayerTimesScreen = "/PrayerTimesScreen";
}

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.splash: (context) => const SplashScreen(),
  AppRoute.home: (context) => const Home(),
  AppRoute.bottomNaveBar: (context) => const NavBarWidget(),
  AppRoute.salah: (context) => PrayerTimesScreen(),
  AppRoute.quran: (context) => const     ListSurahNamePackage(),
  AppRoute.drawer: (context) => const DrawerScreen(),
  // AppRoute.prayerTimesScreen: (context) => PrayerTimesScreen(),
};
