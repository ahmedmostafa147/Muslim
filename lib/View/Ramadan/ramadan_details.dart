import '../../Models/ramadan_load_data.dart';
import 'widget/ramadan_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RamadanDetails extends StatelessWidget {
  final String filePath;

  const RamadanDetails({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    RamadanController ramadanController = Get.put<RamadanController>(
      RamadanController(),
    );

    // Fetch Dhikr data
    ramadanController.fetchRamadan(filePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رمضان'),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(10.0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: ramadanController.ramadans.length,
          itemBuilder: (context, index) {
            Ramadan ramadan = ramadanController.ramadans[index];
            return ListTile(
                title: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.teal,
                        width: 1,
                      ),
                    ),
                    child: Text(ramadan.number)),
                onTap: () => Get.to(
                      RamadanItems(
                        number: ramadan.number,
                        label: ramadan.label,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
