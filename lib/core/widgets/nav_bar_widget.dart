import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../features/home/presentation/pages/home.dart';
import '../../../features/prayer_times/presentation/pages/home_salah.dart';
import '../../../features/quran/presentation/pages/screen/select_type.dart';
import '../../../features/azkar/presentation/pages/azkar_home.dart';
import '../../../features/radio/presentation/pages/radio_home.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const Home(),
      const HomeSalah(),
      const SelectType(),
      const AzkarHome(),
      const RadioHome(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final theme = Theme.of(context);
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'الرئيسية',
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.access_time),
        title: 'الصلاة',
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.menu_book),
        title: 'القرآن',
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.self_improvement),
        title: 'الأذكار',
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.radio),
        title: 'الراديو',
        activeColorPrimary: theme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style6,
    );
  }
}
