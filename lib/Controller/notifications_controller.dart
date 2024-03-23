import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import '../Core/services/notification_service.dart';
import '../Core/services/work_manger_service.dart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class NotificationController extends GetxController {
  var isNotificationOn = false.obs;
  var isAzkarOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadButtonState();
  }

  Future<void> _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNotificationOn.value = prefs.getBool('notificationState') ?? false;
    isAzkarOn.value = prefs.getBool('AzkarState') ?? false;

    if (isNotificationOn.value) {
      await NotificationService().cancelAllNotifications();
      NotificationService().fajr();
      NotificationService().dhuhr();
      NotificationService().asr();
      NotificationService().maghrib();
      NotificationService().isha();
    }
  }

  void toggleNotification(bool? value) async {
    if (value != null) {
      isNotificationOn.value = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('notificationState', value);

      if (value) {
        await schedulePrayerNotifications();
      } else {
        await cancelPrayerNotifications();
      }
    }
  }

  void toggleAzkar(bool? value) async {
    if (value != null) {
      isAzkarOn.value = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('AzkarState', value);

      if (value) {
        await scheduleAzkarNotifications();
      } else {
        await cancelAzkarNotifications();
      }
    }
  }

  Future<void> schedulePrayerNotifications() async {
    await checkBatteryOptimization();
    NotificationService.initializeNotification();
    try {
      NotificationService().fajr();
      NotificationService().dhuhr();
      NotificationService().asr();
      NotificationService().maghrib();
      NotificationService().isha();
      Get.snackbar(
        'نجح',
        'تم جدولة التنبيهات بنجاح',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في جدولة التنبيهات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> cancelPrayerNotifications() async {
    try {
      await NotificationService().cancelAllNotifications();
      Get.snackbar(
        'نجح',
        'تم إلغاء جميع التنبيهات بنجاح',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إلغاء جميع التنبيهات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> scheduleAzkarNotifications() async {
    NotificationService.initializeNotification();
    try {
      Workmanager().initialize(
        zekr,
      );
      Workmanager().registerPeriodicTask(
        "periodic-task-identifier",
        "simplePeriodicTask",
        frequency: const Duration(hours: 4),
      );
      Get.snackbar(
        'Success',
        'Azkar notifications scheduled successfully',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to schedule Azkar notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> cancelAzkarNotifications() async {
    try {
     await NotificationService(). cancelNotificationZekr();
      Workmanager().cancelByUniqueName("periodic-task-identifier");
      Get.snackbar(
        'Success',
        'Azkar notifications canceled successfully',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel Azkar notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkBatteryOptimization() async {
    bool? isOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;

    if (!isOptimizationDisabled!) {
      showBatteryOptimizationDialog();
    }
  }

  void showBatteryOptimizationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("تنبيه"),
        content: const Text(
            "لتشغيل التطبيق بشكل صحيح، يجب تعطيل تحسينات البطارية. يرجى الانتقال إلى إعدادات الهاتف وتعطيل تحسينات البطارية لتطبيقنا."),
        actions: <Widget>[
          TextButton(
            child: const Text("فتح الإعدادات"),
            onPressed: () {
              DisableBatteryOptimization
                  .showDisableBatteryOptimizationSettings();
              Get.back();
            },
          ),
          TextButton(
            child: const Text("إغلاق"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
