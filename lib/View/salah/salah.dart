import 'package:Muslim/widgets/check_notification.dart';

import '../../Controller/location_geo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/date_row_class.dart';
import '../../widgets/time_prayer_widget.dart';

class Salah extends StatelessWidget {
  Salah({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(children: [
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
                          },
                          child: Text(
                            locationController.address.value,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0XFFD4A331)
                                  : Colors.teal,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                        ),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 10.h),
                const ColumnPrayerTime(),
                const NotificationClass(),
              ]),
            ),
          ]),
    );
  }
}
