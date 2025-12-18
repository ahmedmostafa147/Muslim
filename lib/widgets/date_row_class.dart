import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Controller/date.dart';

class DateRowClass extends StatelessWidget {
  const DateRowClass({super.key});

  @override
  Widget build(BuildContext context) {
    final DateController dateController = Get.put(DateController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              dateController.hijriDate.value,
              style: TextStyle(
                fontSize: 15.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Obx(
            () => Text(
              dateController.formattedDate.value,
              style: TextStyle(
                fontSize: 15.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Obx(
            () => Text(
              dateController.gregorianDate.value,
              style: TextStyle(
                fontSize: 15.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
