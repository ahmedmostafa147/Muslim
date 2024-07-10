import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/notification.dart';
import 'package:muslim/Core/constant/themes.dart';import 'package:intl/intl.dart';
import 'package:muslim/Controller/prayer_times.dart';
import 'package:muslim/Core/constant/images.dart';

class NotificationAndPrayerTimesSettingsScreen extends StatelessWidget {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final PrayerTimesController prayerTimesController =
      Get.put(PrayerTimesController());

  NotificationAndPrayerTimesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                // Date Picker
                ListTile(
                  title: const Text('اختر التاريخ'),
                  trailing: Obx(() => Text(DateFormat('yyyy-MM-dd')
                      .format(prayerTimesController.selectedDate.value))),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: prayerTimesController.selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      prayerTimesController.changeDate(pickedDate);
                    }
                  },
                ),
                const Divider(),
                // Calculation Method Picker
                ListTile(
                  title: const Text('طريقة الحساب'),
                  trailing: Obx(() =>
                      Text(prayerTimesController.calculationMethod.value)),
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.0),
                        ),
                        height: 250.h,
                        width: 300.w,
                        child: Wrap(
                          children: [
                            ListTile(
                              title: const Text('جامعة العلوم الإسلامية بكراتشي'),
                              onTap: () => prayerTimesController
                                  .changeCalculationMethod('1'),
                            ),
                            ListTile(
                              title: const Text('رابطة العالم الإسلامي'),
                              onTap: () => prayerTimesController
                                  .changeCalculationMethod('2'),
                            ),
                            ListTile(
                              title: const Text('جامعة أم القرى'),
                              onTap: () => prayerTimesController
                                  .changeCalculationMethod('3'),
                            ),
                            ListTile(
                              title: const Text('الجمعية الإسلامية لأمريكا الشمالية'),
                              onTap: () => prayerTimesController
                                  .changeCalculationMethod('4'),
                            ),
                            ListTile(
                              title: const Text('الهيئة المصرية العامة للمساحة'),
                              onTap: () => prayerTimesController
                                  .changeCalculationMethod('5'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                // Madhab Picker
                ListTile(
                  title: const Text('المذهب'),
                  trailing: Obx(() => Text(prayerTimesController.madhab.value)),
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.0),
                        ),
                        child: Wrap(
                          children: [
                            ListTile(
                              title: const Text('شافعي'),
                              onTap: () =>
                                  prayerTimesController.changeMadhab('Shafi'),
                            ),
                            ListTile(
                              title: const Text('حنفي'),
                              onTap: () =>
                                  prayerTimesController.changeMadhab('Hanafi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
            Obx(() {
              if (prayerTimesController.prayerTimes.value == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  BuildPrayerTimeItemRow(
                    name: 'الفجر',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.fajr
                        .toString(),
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'الظهر',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.dhuhr
                        .toString(),
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'العصر',
                    imagePath: Assets.imagesIsha,
                    time:
                        prayerTimesController.prayerTimes.value!.asr.toString(),
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'المغرب',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.maghrib
                        .toString(),
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'العشاء',
                    imagePath: Assets.imagesIsha,
                    time: prayerTimesController.prayerTimes.value!.isha
                        .toString(),
                  ),
                ],
              );
            }),
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
                          value: notificationController.isNotificationOn.value,
                          onChanged: notificationController.toggleNotification,
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
          ],
        ),
      ),
    );
  }
}

class BuildPrayerTimeItemRow extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;

  const BuildPrayerTimeItemRow({super.key, 
    required this.name,
    required this.imagePath,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(fontSize: 15.sp)),
            Text(time,
                style: TextStyle(
                    fontSize: 15.sp, color: Theme.of(context).primaryColor)),
            Image.asset(imagePath, width: 25, height: 25),
          ],
        ),
      ),
    );
  }
}
