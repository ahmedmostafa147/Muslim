import 'package:muslim/features/prayer_times/data/datasources/pray_load_data.dart';

import 'widget/pray_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayDetails extends StatelessWidget {
  final String filePath;

  const PrayDetails({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    PrayController prayController = Get.put<PrayController>(
      PrayController(),
    );

    
    prayController.fetchPray(filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الادعية'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: prayController.prays.length,
          itemBuilder: (context, index) {
            Pray pray = prayController.prays[index];
            
            return PrayItems(
              pray: pray.text,
            );
          },
        ),
      ),
    );
  }
}
