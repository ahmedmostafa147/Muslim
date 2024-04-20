import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/location_geo_controller.dart';
import '../../../Core/constant/style.dart';
import '../../Salah/salah.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/time_prayer_widget.dart';

class HomeLocationWidget extends StatelessWidget {
  HomeLocationWidget({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color:Theme.of(context).primaryColor,
            width: 1.5),
      ),
      child: Column(
        children: [
          Obx(() {
            if (locationController.isLoading.value) {
              return const LoadingWidget();
            } else {
              return TextButton(
                onPressed: () async {
                  await locationController.getCurrentLocation();
                },
                child: Text(
                  locationController.address.value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
          }),
          GestureDetector(
              onTap: () {
                Get.to(() => Salah());
              },
              child: const PrayerTimeRow()),
        ],
      ),
    );
  }
}
