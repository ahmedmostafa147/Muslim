import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/constants/images.dart';
import '../../../home/presentation/pages/home.dart';
import '../../../../core/widgets/nav_bar_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1000,
      splashIconSize: 250.r,
      splash: Image.asset(Assets.imagesSplash),
      nextScreen: const NavBarWidget(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.theme,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
