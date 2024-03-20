import '../Core/constant/images.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/prayer_time_controller.dart';

class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrayerTimesControllerForRow prayerTimesControllerForRow =
        Get.put<PrayerTimesControllerForRow>(PrayerTimesControllerForRow());

    return Obx(() {
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
                time: DateFormat.jm("ar").format(
                    prayerTimesControllerForRow.prayerTimes.value!.fajr),
              ),
              BuildPrayerTimeItemRow(
                name: 'الظهر',
                imagePath: Assets.imagesDhuhr,
                time: DateFormat.jm("ar").format(
                    prayerTimesControllerForRow.prayerTimes.value!.dhuhr),
              ),
              BuildPrayerTimeItemRow(
                name: 'العصر',
                imagePath: Assets.imagesAsr,
                time: DateFormat.jm("ar")
                    .format(prayerTimesControllerForRow.prayerTimes.value!.asr),
              ),
              BuildPrayerTimeItemRow(
                name: 'المغرب',
                imagePath: Assets.imagesMaghrib,
                time: DateFormat.jm("ar").format(
                    prayerTimesControllerForRow.prayerTimes.value!.maghrib),
              ),
              BuildPrayerTimeItemRow(
                name: 'العشاء',
                imagePath: Assets.imagesIsha,
                time: DateFormat.jm("ar").format(
                    prayerTimesControllerForRow.prayerTimes.value!.isha),
              ),
            ],
          )
        ],
      );
    });
  }
}

class ColumnPrayerTime extends StatelessWidget {
  const ColumnPrayerTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrayerTimesControllerForColumn prayerTimesControllerForColumn =
        Get.put<PrayerTimesControllerForColumn>(
            PrayerTimesControllerForColumn());
    return Obx(() {
      return ListView(
        padding: const EdgeInsets.all(5.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(Assets.imagesBackSa),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      prayerTimesControllerForColumn.arabicNextPrayerName.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "الوقت المتبقي",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        Text(
                          prayerTimesControllerForColumn
                              .formatRemainingTime(
                                  prayerTimesControllerForColumn
                                      .timeRemaining.value)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'الفجر',
                imagePath: Assets.imagesFajr,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.fajr,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.fajr
                        ? Colors.teal[50]!
                        : Colors.transparent,
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'الشروق',
                imagePath: Assets.imagesSunrise,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.sunrise,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.sunrise
                        ? const Color.fromARGB(255, 203, 227, 226)
                        : Colors.transparent,
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'الظهر',
                imagePath: Assets.imagesDhuhr,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.dhuhr,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.dhuhr
                        ? Colors.teal[50]!
                        : Colors.transparent,
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'العصر',
                imagePath: Assets.imagesAsr,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.asr,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.asr
                        ? Colors.teal[50]!
                        : Colors.transparent,
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'المغرب',
                imagePath: Assets.imagesMaghrib,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.maghrib,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.maghrib
                        ? Colors.teal[50]!
                        : Colors.transparent,
              ),
              SizedBox(
                height: 10.h,
              ),
              BuildPrayerTimeItemColumn(
                name: 'العشاء',
                imagePath: Assets.imagesIsha,
                time: DateFormat.jm("ar").format(
                  prayerTimesControllerForColumn.prayerTimes.value!.isha,
                ),
                containerColor:
                    prayerTimesControllerForColumn.nextPrayer.value ==
                            Prayer.isha
                        ? Colors.teal[50]!
                        : Colors.transparent,
              ),
            ],
          ),
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

class BuildPrayerTimeItemColumn extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;
  final Color containerColor;
  const BuildPrayerTimeItemColumn({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.time,
    required this.containerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 30.h, width: 30.w, child: Image.asset(imagePath)),
              SizedBox(
                width: 20.w,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
