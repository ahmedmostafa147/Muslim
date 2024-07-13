import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:muslim/View/Quran/screen/surah_name_p.dart';

import '../Core/constant/images.dart';
import '../Core/constant/themes.dart';
import '../View/Azkar/azkar_home.dart';
import '../View/Radio/radio_home.dart';
import '../View/home/home.dart';
import '../View/salah/home_salah.dart';

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
        PrayerTimesScreen(),
        const ListSurahNamePackage(),
        const Home(),
        AzkarHome(),
        const RadioHomeScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          icon: const ImageIcon(
            AssetImage(
              Assets.images14703159,
            ),
          ),
          title: ("الصلاة"),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          icon: const ImageIcon(
            AssetImage(Assets.imagesCatalogMagazine),
          ),
          title: ("القرآن"),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          icon: const ImageIcon(
            AssetImage(Assets.imagesHouseBlank),
          ),
          title: ("الرئيسية"),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          icon: const ImageIcon(
            AssetImage(Assets.imagesPersonPraying),
          ),
          title: ("الاذكار"),
        ),
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Theme.of(context).primaryColor,
          icon: const ImageIcon(
            AssetImage(Assets.imagesCircleWaveformLines),
          ),
          title: ("الراديو"),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
      ),
      navBarStyle: NavBarStyle.style12);
}
