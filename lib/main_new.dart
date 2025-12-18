import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'Core/constant/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize date formatting for Arabic
  await initializeDateFormatting('ar');

  runApp(const Muslim());
}

class Muslim extends StatelessWidget {
  const Muslim({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          locale: const Locale('ar'),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          title: 'Muslim',
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
