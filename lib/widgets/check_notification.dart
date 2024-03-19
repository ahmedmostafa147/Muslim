import '../Controller/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationClass extends StatelessWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());
    return Column(
      children: [
        Obx(() => Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal, width: 1.0),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(44, 212, 163, 49)
                          : const Color.fromARGB(44, 0, 150, 135),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Checkbox(
                      value: notificationController.isNotificationOn.value,
                      onChanged: notificationController.toggleNotification,
                      activeColor:
                          (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0XFFD4A331)
                              : Colors.teal),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 10.h,
        ),
        Obx(() => Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal, width: 1.0),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(44, 212, 163, 49)
                          : const Color.fromARGB(44, 0, 150, 135),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Checkbox(
                      value: notificationController.isAzkarOn.value,
                      onChanged: notificationController.toggleAzkar,
                      activeColor:
                          (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0XFFD4A331)
                              : Colors.teal),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
