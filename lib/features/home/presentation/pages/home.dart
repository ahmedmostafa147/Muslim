import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/grid_quran_screens.dart';
import '../widgets/last_read.dart';
import 'drawer.dart';
import '../widgets/home_grid_icons.dart';
import '../widgets/home_location_widget.dart';
import '../widgets/home_aya_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                HomeLocationWidget(),
                SizedBox(height: 10.h),
                const LastRead(),
                SizedBox(height: 10.h),
                const GridQuranScreens(),
                SizedBox(height: 10.h),
                const HomeAyaWidget(),
                SizedBox(height: 10.h),
                const HomeGridViewIcons(),
                SizedBox(height: 10.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
