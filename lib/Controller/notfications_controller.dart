import 'package:Muslim/Controller/location_geo_controller.dart';
import 'package:Muslim/Controller/prayer_time_controller.dart';
import 'package:Muslim/widgets/time_prayer_widget.dart';
import 'package:flutter/material.dart';

import '../Core/services/notification_service.dart';
import '../Core/services/work_manger_service.dart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class NotificationController extends GetxController {
  var isNotificationOn = false.obs;
  var isAzkarOn = false.obs;
  final PrayerTimesControllerForRow prayerTimesControllerForRow =
      Get.put<PrayerTimesControllerForRow>(PrayerTimesControllerForRow());
  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  @override
  void onInit() {
    super.onInit();
    _loadButtonState();
  }

  Future<void> _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNotificationOn.value = prefs.getBool('notificationState') ?? false;
    isAzkarOn.value = prefs.getBool('AzkarState') ?? false;
  }

  void toggleNotification(bool? value) async {
    if (value != null) {
      isNotificationOn.value = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('notificationState', value);

      if (value) {
        await _schedulePrayerNotifications();
      } else {
        await _cancelPrayerNotifications();
      }
    }
  }

  void toggleAzkar(bool? value) async {
    if (value != null) {
      isAzkarOn.value = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('AzkarState', value);

      if (value) {
        await _scheduleAzkarNotifications();
      } else {
        await _cancelAzkarNotifications();
      }
    }
  }

  Future<void> _schedulePrayerNotifications() async {
    await locationController.getCurrentLocation();
    NotificationService.initializeNotification();
    try {
      prayerTimesControllerForRow.schedulePrayerNotifications();

      Get.snackbar(
        'Success',
        'Prayer notifications scheduled successfully',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to schedule prayer notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _cancelPrayerNotifications() async {
    try {
      NotificationService.cancelAllNotifications();
      Get.snackbar(
        'Success',
        'All notifications canceled successfully',
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel all notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _scheduleAzkarNotifications() async {
    NotificationService.initializeNotification();
    try {
      Workmanager().initialize(
        zekr,
      );
      Workmanager().registerPeriodicTask(
        "periodic-task-identifier",
        "simplePeriodicTask",
        frequency: const Duration(minutes: 30),
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

  Future<void> _cancelAzkarNotifications() async {
    try {
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
}
