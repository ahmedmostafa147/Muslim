import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/widgets/matreial_button.dart';
import 'setting_prayer.dart';
import 'widget/prayer_column_items.dart';
import '../../Controller/prayer_times.dart';
import '../../Controller/location.dart';
import '../../Core/constant/images.dart';
import '../../Core/constant/style.dart';
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
            children: [
              Column(
                children: [
                  const Divider(),
                  const DateRowClass(),
                  const Divider(),
                  SizedBox(height: 10.h),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1.0),
                      ),
                      child: Column(
                        children: [
                          Text("الوقت المتبقي للصلاة القادمة",
                              style: TextStyle(fontSize: 17.sp)),
                          SizedBox(height: 10.h),
                          Text(
                            prayerTimesController.timeRemaining.value,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'الفجر',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.fajr
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Fajr'
                            ? ColorsStyleApp.hoverLight
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'الظهر',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.dhuhr
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Dhuhr'
                            ? ColorsStyleApp.hoverLight
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'العصر',
                    imagePath: Assets.imagesIsha,
                    time:
                        prayerTimesController.prayerTimes.value!.asr.toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Asr'
                            ? ColorsStyleApp.hoverLight
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'المغرب',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.maghrib
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Maghrib'
                            ? ColorsStyleApp.hoverLight
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'العشاء',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.isha
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Isha'
                            ? ColorsStyleApp.hoverLight
                            : Colors.transparent,
                  ),
                  SizedBox(height: 10.h),
                  CustomMaterialButton(
                    fontAwesomeIcons: Icons.settings,
                    onPressed: () {
                      Get.to(NotificationSettingsScreen());
                    },
                    buttonText: "إعدادات الصلاة و الاشعارات ",
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
