import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muslim/Controller/prayer_times.dart';

class PrayerTimesSettingsScreen extends StatelessWidget {
  final PrayerTimesController prayerTimesController =
      Get.put(PrayerTimesController());

  PrayerTimesSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات مواقيت الصلاة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Picker
            ListTile(
              title: Text('اختر التاريخ'),
              trailing: Obx(() => Text(DateFormat('yyyy-MM-dd').format(prayerTimesController.selectedDate.value))),
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
              title: Text('طريقة الحساب'),
              trailing: Obx(() => Text(prayerTimesController.calculationMethod.value)),
              onTap: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: Wrap(
                      children: [
                        ListTile(
                          title: Text('جامعة العلوم الإسلامية بكراتشي'),
                          onTap: () => prayerTimesController.changeCalculationMethod('1'),
                        ),
                        ListTile(
                          title: Text('رابطة العالم الإسلامي'),
                          onTap: () => prayerTimesController.changeCalculationMethod('2'),
                        ),
                        ListTile(
                          title: Text('جامعة أم القرى'),
                          onTap: () => prayerTimesController.changeCalculationMethod('3'),
                        ),
                        ListTile(
                          title: Text('الجمعية الإسلامية لأمريكا الشمالية'),
                          onTap: () => prayerTimesController.changeCalculationMethod('4'),
                        ),
                        ListTile(
                          title: Text('الهيئة المصرية العامة للمساحة'),
                          onTap: () => prayerTimesController.changeCalculationMethod('5'),
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
              title: Text('المذهب'),
              trailing: Obx(() => Text(prayerTimesController.madhab.value)),
              onTap: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: Wrap(
                      children: [
                        ListTile(
                          title: Text('شافعي'),
                          onTap: () => prayerTimesController.changeMadhab('Shafi'),
                        ),
                        ListTile(
                          title: Text('حنفي'),
                          onTap: () => prayerTimesController.changeMadhab('Hanafi'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
