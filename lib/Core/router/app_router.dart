import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../widgets/nav_bar_widget.dart';

/// Application route paths
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String bottomNavBar = '/main';
  static const String prayerTimes = '/prayer-times';
  static const String quran = '/quran';
  static const String drawer = '/drawer';
  static const String quranReader = '/quran/:surahNumber';
  static const String radio = '/radio';
  static const String qibla = '/qibla';
  static const String azkar = '/azkar';
  static const String azkarDetails = '/azkar/:categoryId';
  static const String bookmarks = '/bookmarks';
  static const String favorites = '/favorites';
  static const String ramadan = '/ramadan';
  static const String stories = '/stories';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreenNew(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreenNew(),
    ),
    GoRoute(
      path: AppRoutes.bottomNavBar,
      name: 'main',
      builder: (context, state) => const NavBarWidget(),
    ),
    GoRoute(
      path: AppRoutes.prayerTimes,
      name: 'prayer-times',
      builder: (context, state) => const PrayerTimesScreenNew(),
    ),
    // TODO: Add remaining routes during feature migration
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);

/// Extension for easier navigation
extension GoRouterExtension on BuildContext {
  void pushRoute(String route, {Object? extra}) =>
      GoRouter.of(this).push(route, extra: extra);
  void goRoute(String route, {Object? extra}) =>
      GoRouter.of(this).go(route, extra: extra);
  void popRoute() => GoRouter.of(this).pop();
}
