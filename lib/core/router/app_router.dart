import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/home/presentation/pages/home.dart';
import '../../features/prayer_times/presentation/pages/home_salah.dart';
import '../../features/quran/presentation/pages/screen/surah_name_p.dart';
import '../../features/azkar/presentation/pages/azkar_home.dart';
import '../../features/qibla/presentation/pages/qibla.dart';
import '../../features/radio/presentation/pages/radio_home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/prayer-times',
      builder: (context, state) => PrayerTimesScreen(),
    ),
    GoRoute(
      path: '/quran',
      builder: (context, state) => const ListSurahNamePackage(),
    ),
    GoRoute(
      path: '/azkar',
      builder: (context, state) =>  AzkarHome(),
    ),
    GoRoute(
      path: '/qibla',
      builder: (context, state) => const QiblaScreen(),
    ),
    GoRoute(
      path: '/radio',
      builder: (context, state) => const RadioHomeScreen(),
    ),
  ],
);
