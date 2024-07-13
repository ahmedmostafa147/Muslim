import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes.dart';
import 'Core/constant/themes.dart';
import 'Core/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialServices();

  // Initialize date formatting with Arabic locale
  await initializeDateFormatting('ar');

  runApp(const Muslim());
}

class Muslim extends StatelessWidget {
  const Muslim({
    super.key,
  });
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale('ar'),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          title: 'Muslim',
          routes: routes,
          initialRoute: AppRoute.splash,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
