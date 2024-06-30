import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/prayer_times.dart';
import '../../Controller/location.dart';
import '../../Core/constant/images.dart';
import '../../Core/constant/style.dart';
import '../../widgets/check_notification.dart';
import '../../widgets/date_row_class.dart';

class PrayerTimesScreen extends StatelessWidget {
  final PrayerTimesController prayerTimesController =
      Get.put(PrayerTimesController());
  final LocationController locationController = Get.put(LocationController());

  PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (prayerTimesController.prayerTimes.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    const Divider(),
                    const DateRowClass(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    Column(children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await locationController.getCurrentLocation();
                                await prayerTimesController.updatePrayerTimes();
                              },
                              child: Text(
                                locationController.address.value,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const Icon(Icons.location_on),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(height: 10.h),
                    const Divider(),
                    Column(
                      children: [
                        Text("الوقت المتبقي للصلاة القادمة",
                            style: TextStyle(fontSize: 15.sp)),
                        Text(
                          prayerTimesController.timeRemaining.value,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    BuildPrayerTimeItemColumn(
                      name: 'الفجر',
                      imagePath: Assets.imagesIsha,
                      time: prayerTimesController.prayerTimes.value!.fajr
                          .toString(),
                      containerColor:
                          prayerTimesController.nextPrayer.value == 'Fajr'
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? ColorsStyleApp.hoverDark
                                  : ColorsStyleApp.hoverLight
                              : Colors.transparent,
                    ),
                    BuildPrayerTimeItemColumn(
                      name: 'الظهر',
                      imagePath: Assets.imagesIsha,
                      time: prayerTimesController.prayerTimes.value!.dhuhr
                          .toString(),
                      containerColor:
                          prayerTimesController.nextPrayer.value == 'Dhuhr'
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? ColorsStyleApp.hoverDark
                                  : ColorsStyleApp.hoverLight
                              : Colors.transparent,
                    ),
                    BuildPrayerTimeItemColumn(
                      name: 'العصر',
                      imagePath: Assets.imagesIsha,
                      time: prayerTimesController.prayerTimes.value!.asr
                          .toString(),
                      containerColor:
                          prayerTimesController.nextPrayer.value == 'Asr'
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? ColorsStyleApp.hoverDark
                                  : ColorsStyleApp.hoverLight
                              : Colors.transparent,
                    ),
                    BuildPrayerTimeItemColumn(
                      name: 'المغرب',
                      imagePath: Assets.imagesIsha,
                      time: prayerTimesController.prayerTimes.value!.maghrib
                          .toString(),
                      containerColor:
                          prayerTimesController.nextPrayer.value == 'Maghrib'
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? ColorsStyleApp.hoverDark
                                  : ColorsStyleApp.hoverLight
                              : Colors.transparent,
                    ),
                    BuildPrayerTimeItemColumn(
                      name: 'العشاء',
                      imagePath: Assets.imagesIsha,
                      time: prayerTimesController.prayerTimes.value!.isha
                          .toString(),
                      containerColor:
                          prayerTimesController.nextPrayer.value == 'Isha'
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? ColorsStyleApp.hoverDark
                                  : ColorsStyleApp.hoverLight
                              : Colors.transparent,
                    ),
                    SizedBox(height: 10.h),
                    const NotificationClass(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class BuildPrayerTimeItemColumn extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;
  final Color containerColor;

  const BuildPrayerTimeItemColumn({
    super.key,
    required this.name,
    required this.imagePath,
    required this.time,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Image.asset(imagePath),
                ),
                SizedBox(width: 20.w),
                Text(
                  name,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
