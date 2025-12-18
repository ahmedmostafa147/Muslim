import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Core/constant/themes.dart';
import '../Controller/notification.dart';

class NotificationClass extends StatelessWidget {
  const NotificationClass({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.0),
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
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1.0),
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
                  child: Checkbox(
                    value: notificationController.isAzkarOn.value,
                    onChanged: notificationController.toggleAzkar,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
