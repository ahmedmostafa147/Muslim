
import 'package:muslim/Controller/prayer_times.dart';
import 'package:muslim/widgets/loading_widget.dart';
import '../Core/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({super.key});

  @override
  Widget build(BuildContext context) {
    final PrayerTimesController prayerTimesController =
        Get.put(PrayerTimesController());
    return Obx(() {
      if (prayerTimesController.prayerTimes.value == null) {
        return const Center(child: LoadingWidget());
      }
      
      return ListView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BuildPrayerTimeItemRow(
                name: 'الفجر',
                imagePath: Assets.imagesFajr,
                time: prayerTimesController.prayerTimes.value!.fajr.toString(),
              ),
              BuildPrayerTimeItemRow(
                  name: 'الظهر',
                  imagePath: Assets.imagesDhuhr,
                  time: prayerTimesController.prayerTimes.value!.dhuhr),
              BuildPrayerTimeItemRow(
                  name: 'العصر',
                  imagePath: Assets.imagesAsr,
                  time: prayerTimesController.prayerTimes.value!.asr),
              BuildPrayerTimeItemRow(
                  name: 'المغرب',
                  imagePath: Assets.imagesMaghrib,
                  time: prayerTimesController.prayerTimes.value!.maghrib),
              BuildPrayerTimeItemRow(
                  name: 'العشاء',
                  imagePath: Assets.imagesIsha,
                  time: prayerTimesController.prayerTimes.value!.isha),
            ],
          )
        ],
      );
    });
  }
}

class BuildPrayerTimeItemRow extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;
  const BuildPrayerTimeItemRow(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 40.h, width: 40.w, child: Image.asset(imagePath)),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
