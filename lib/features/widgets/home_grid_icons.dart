

import 'package:muslim/features/azkar/presentation/pages/azkar_home.dart';
import 'package:muslim/features/prayer_times/presentation/pages/home_salah.dart';
import 'package:muslim/features/qibla/presentation/pages/qibla.dart';
import 'package:muslim/features/quran/presentation/pages/screen/surah_name_p.dart';
import 'package:muslim/features/radio/presentation/pages/radio_home.dart';
import 'package:muslim/features/ramadan/presentation/pages/ramadan.dart';
import 'package:muslim/features/story/presentation/pages/story.dart';
import 'package:muslim/features/widgets/pray_grid_view_home.dart';

import '../../../../core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'home_icon_text_for_grid.dart';

class HomeGridViewIcons extends StatelessWidget {
  const HomeGridViewIcons({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      children: [
        IconAndTextGridView(
          onTap: () {
            Get.to(
              const ListSurahNamePackage(),
            );
          },
          image: Assets.imagesQuranforselecte,
          text: 'القرآن الكريم',
        ),
        IconAndTextGridView(
            onTap: () {
                               

            },
            image: Assets.imagesAzkar,
            text: "القراء"),
        IconAndTextGridView(
          onTap: () {
            Get.to(const RadioHomeScreen());
          },
          image: Assets.imagesRadio,
          text: 'الراديو',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(
              PrayerTimesScreen(),
            );
          },
          image: Assets.imagesPray,
          text: 'الصلاة',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(AzkarHome());
          },
          image: Assets.imagesPray,
          text: 'الاذكار',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(PrayHome());
          },
          image: Assets.imagesPray,
          text: 'الدعاء',
        ),
        // IconAndTextGridView(
        //   onTap: () {
        //     Get.to(const ());
        //   },
        //   image: Assets.imagesMuhammad,
        //   text: 'الحديث',
        // ),
        // IconAndTextGridView(
        //   onTap: () {},
        //   image: Assets.imagesRosary,
        //   text: 'التسبيح',
        // ),
        IconAndTextGridView(
          onTap: () {
            Get.to(const QiblaScreen());
          },
          image: Assets.imagesRadio,
          text: 'اتجاة القبلة',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(const StoryHome());
          },
          image: Assets.imagesPray,
          text: 'قصص',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(const RamadanHome());
          },
          image: Assets.imagesPray,
          text: 'رمضان',
        ),
        // IconAndTextGridView(
        //   onTap: () {
        //     Get.to(const SettingsScreen());
        //   },
        //   image: Assets.imagesSettings,
        //   text: 'الاعدادات',
        // ),
      ],
    );
  }
}
