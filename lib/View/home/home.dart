import '../../routes.dart';
import '../../Core/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Radio/radio_home.dart';
import '../../widgets/card_text_icon_widget.dart';
import '../../widgets/date_row_class.dart';
import 'Drawer/drawer.dart';
import 'widgets/home_grid_icons.dart';
import 'widgets/home_location_widget.dart';
import '../../widgets/doa_card_widget.dart';
import 'widgets/home_aya_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
              icon: const Icon(Icons.dark_mode)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.ios_share_outlined))
        ],
      ),
      drawer: const DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            children: [
              Column(
                children: [
                  const Divider(),
                  const DateRowClass(),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "يومك سعيد 👋",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  HomeLocationWidget(),
                ],
              ),
              SizedBox(height: 10.h),
              CardTextIconWidget(
                onTap: () {
                  Get.toNamed(AppRoute.quran);
                },
                text: "القرآن الكريم",
                icon: Assets.imagesHolyQuran,
              ),
              SizedBox(height: 10.h),
              const HomeAyaWidget(),
              SizedBox(height: 10.h),
              const HomeGridViewIcons(),
              SizedBox(height: 10.h),
              DoaCardWidget(),
              SizedBox(height: 10.h),
              CardTextIconWidget(
                onTap: () {
                  Get.to(() => const RadioHomeScreen());
                },
                text: "إذاعة القرآن الكريم ",
                icon: Assets.imagesRadio,
              ),
              SizedBox(height: 10.h),
            ]),
      ),
    );
  }
}
