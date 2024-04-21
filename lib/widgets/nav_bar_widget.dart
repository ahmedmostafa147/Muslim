import 'package:muslim/routes.dart';

import '../View/Radio/radio_home.dart';

import '../Core/constant/images.dart';
import '../Core/constant/themes.dart';

import '../View/Azkar/azkar_home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../View/home/home.dart';
import '../View/Quran/screen/master_quran.dart';
import '../View/Salah/salah.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  List<Widget> _buildScreens() => [
        Salah(),
        const QuranHomePage(),
        const Home(),
        AzkarHome(),
        const RadioHomeScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).brightness == Brightness.dark
              ? darkTheme.primaryColor
              : lightTheme.primaryColor,
          icon: const ImageIcon(
            AssetImage(
              Assets.images14703159,
            ),
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          iconSize: 30.r,
          icon: const ImageIcon(
            AssetImage(Assets.imagesCatalogMagazine),
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          iconSize: 30.r,
          icon: const ImageIcon(
            AssetImage(Assets.imagesHouseBlank),
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          iconSize: 30.r,
          icon: const ImageIcon(
            AssetImage(Assets.imagesPersonPraying),
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          iconSize: 30.r,
          icon: const ImageIcon(
            AssetImage(Assets.imagesCircleWaveformLines),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navBarHeight: 60.h,
      bottomScreenMargin: 60.h,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
      ),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInCirc,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
      ),
      navBarStyle:
          NavBarStyle.style5 // Choose the nav bar style with this property
      );
}
