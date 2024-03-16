import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Models/azkar_load_data.dart';
import 'widget/azkar_items.dart';

class AzkarDetails extends StatelessWidget {
  final String filePath;

  const AzkarDetails({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    DhikrController dhikrController = Get.put<DhikrController>(
      DhikrController(),
    );

    dhikrController.fetchDhikrs(filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الأذكار'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: dhikrController.dhikrs.length,
          itemBuilder: (context, index) {
            Dhikr dhikr = dhikrController.dhikrs[index];
            return AzkarItem(
              zekr: dhikr.text,
              hint: dhikr.hint,
              number: dhikr.number,
            );
          },
        ),
      ),
    );
  }
}
