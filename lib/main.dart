import 'Core/constant/themes.dart';
import 'Core/services/services.dart';
import 'View/Splash%20Screen/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  );
  const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  );

  initializeDateFormatting('ar_EG').then((_) => runApp(
      DevicePreview(enabled: false, builder: (context) => const Muslim())));
}

class Muslim extends StatelessWidget {
  const Muslim({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            fallbackLocale: const Locale('ar'),
            locale: const Locale('ar'),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            title: 'Muslim',
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
