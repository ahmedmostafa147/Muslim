import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muslim/Controller/notification.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'widget/prayer_column_items.dart';
import '../../Controller/prayer_times.dart';
import '../../Controller/location.dart';
import '../../Core/constant/images.dart';
import '../../widgets/date_row_class.dart';

class PrayerTimesScreen extends StatelessWidget {
  final PrayerTimesController prayerTimesController =
      Get.put(PrayerTimesController());
  final LocationController locationController = Get.put(LocationController());
  final NotificationController notificationController =
      Get.put(NotificationController());
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        image: const DecorationImage(
                            image: AssetImage(Assets.imagesMo),
                            fit: BoxFit.cover,
                            opacity: 0.4
                            // Adjust the fit as needed
                            ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الصلاة القادمة هي صلاة",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                prayerTimesController.nextPrayerName.value,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "الوقت المتبقي",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                prayerTimesController.timeRemaining.value,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                          Image(
                              image:
                                  const AssetImage(Assets.imagesSalahbetween),
                              width: 60.w,
                              height: 60.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          prayerTimesController.decrementDate();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Obx(() => Text(DateFormat('EEE dd MMM yyyy', 'ar')
                          .format(prayerTimesController.selectedDate.value))),
                      IconButton(
                        onPressed: () {
                          prayerTimesController.incrementDate();
                        },
                        icon: const Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'الفجر',
                    imagePath: Assets.imagesFajr,
                    time: prayerTimesController.prayerTimes.value!.fajr
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Fajr'
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'الظهر',
                    imagePath: Assets.imagesDhuhr,
                    time: prayerTimesController.prayerTimes.value!.dhuhr
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Dhuhr'
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'العصر',
                    imagePath: Assets.imagesAsr,
                    time:
                        prayerTimesController.prayerTimes.value!.asr.toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Asr'
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'المغرب',
                    imagePath: Assets.imagesMaghrib,
                    time: prayerTimesController.prayerTimes.value!.maghrib
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Maghrib'
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                  ),
                  BuildPrayerTimeItemColumn(
                    name: 'العشاء',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.isha
                        .toString(),
                    containerColor:
                        prayerTimesController.nextPrayer.value == 'Isha'
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تذكير بمواقيت الصلاة ',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorsStyleApp.hoverLight,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Obx(() => Checkbox(
                                value: notificationController
                                    .isNotificationOn.value,
                                onChanged:
                                    notificationController.toggleNotification,
                                activeColor: Theme.of(context).primaryColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تذكير بالأذكار ',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorsStyleApp.hoverLight,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Obx(() => Checkbox(
                                value: notificationController.isAzkarOn.value,
                                onChanged: notificationController.toggleAzkar,
                                activeColor: Theme.of(context).primaryColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // CustomMaterialButton(
                  //   fontAwesomeIcons: Icons.settings,
                  //   onPressed: () {
                  //     Get.to(NotificationAndPrayerTimesSettingsScreen());
                  //   },
                  //   buttonText: "إعدادات الصلاة و الاشعارات ",
                  // ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
