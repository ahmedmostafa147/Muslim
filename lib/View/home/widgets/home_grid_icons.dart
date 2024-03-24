import '../../../Core/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Azkar/azkar_home.dart';
import '../../Pray/pray_grid_view_home.dart';
import '../../Qibla/qibla.dart';
import '../../Quran/screen/master_quran.dart';
import '../../Quran/screen/reader_screen.dart';
import '../../Radio/radio_home.dart';
import '../../Ramadan/ramadan.dart';
import '../../Salah/salah.dart';
import '../../Story/story.dart';
import 'home_icon_text_for_grid.dart';

class HomeGridViewIcons extends StatelessWidget {
  const HomeGridViewIcons({Key? key}) : super(key: key);
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
            Get.to(const QuranHomePage());
          },
          image: Assets.imagesQuran,
          text: 'القرآن',
        ),
        IconAndTextGridView(
            onTap: () {
              Get.to(ReaderList());
            },
            image: Assets.imagesAudioBook,
            text: "القرآن مسموع"),
        IconAndTextGridView(
          onTap: () {
            Get.to(const RadioHomeScreen());
          },
          image: Assets.imagesRadiogrid,
          text: 'الراديو',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(Salah());
          },
          image: Assets.imagesGridmosque,
          text: 'الصلاة',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(AzkarHome());
          },
          image: Assets.imagesPrayingGrid,
          text: 'الاذكار',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(PrayHome());
          },
          image: Assets.imagesPraying,
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
          image: Assets.imagesMecca,
          text: 'اتجاة القبلة',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(const StoryHome());
          },
          image: Assets.imagesScript,
          text: 'قصص',
        ),
        IconAndTextGridView(
          onTap: () {
            Get.to(const RamadanHome());
          },
          image: Assets.imagesRamdan,
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
