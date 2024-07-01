import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  var isNotificationOn = false.obs;
  var isAzkarOn = false.obs;
  var selectedTone = 'default'.obs; // ملاحظة: تغيير اسم المتغير

  late NotificationService notificationService;

  @override
  void onInit() {
    super.onInit();
    notificationService = NotificationService();
    getNotificationStatus();
    getAzkarStatus();
   
  }

  void getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedValue = prefs.getBool('isNotificationOn');
    isNotificationOn.value = storedValue ?? false;
    print('Notification status: $isNotificationOn');
  }

  void getAzkarStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedValue = prefs.getBool('isAzkarOn');
    isAzkarOn.value = storedValue ?? false;
    print('Azkar status: $isAzkarOn');
  }

 

  void toggleNotification(bool? value) async {
    isNotificationOn.value = value ?? false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationOn', isNotificationOn.value);

    if (isNotificationOn.value) {
      await schedulePrayerNotifications();
      Get.snackbar(
        'تنبيه',
        'تم تفعيل الإشعارات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print('Notifications enabled');
    } else {
      notificationService.cancelAllNotifications();
      Get.snackbar(
        'تنبيه',
        'تم تعطيل الإشعارات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Notifications disabled');
    }
  }

  void toggleAzkar(bool? value) async {
    isAzkarOn.value = value ?? false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAzkarOn', isAzkarOn.value);
    print('Azkar toggled: $isAzkarOn');
    if (isAzkarOn.value) {
      // scheduleAzkarNotifications();
    } else {
      // cancelNotificationZekr();
    }
  }

  

  Future<void> schedulePrayerNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cachedData = prefs.getString('cachedPrayerTimes');
    if (cachedData != null) {
      var data = json.decode(cachedData);
      var prayerTimes = data['prayerTimes'];
      var prayerTimesMap = {
        'الفجر': prayerTimes['Fajr'],
        'الظهر': prayerTimes['Dhuhr'],
        'العصر': prayerTimes['Asr'],
        'المغرب': prayerTimes['Maghrib'],
        'العشاء': prayerTimes['Isha'],
      };

      prayerTimesMap.forEach((prayer, time) {
        var prayerTime = DateFormat('hh:mm a').parse(time);
        var now = DateTime.now();
        var prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          prayerTime.hour,
          prayerTime.minute,
        );

        // Ensure the prayer time is in the future
        if (prayerDateTime.isBefore(now)) {
          prayerDateTime = prayerDateTime.add(const Duration(days: 1));
        }

        notificationService.schedulePrayerNotification(
          id: prayer.hashCode,
          title: 'وقت الصلاة',
          body: 'حان الآن وقت صلاة $prayer',
          dateTime: prayerDateTime,
        );
        print('Scheduled notification for $prayer at $prayerDateTime');
      });
    }
  }

  // Schedule a test notification after 10 seconds
  void scheduleTestNotification() {
    final now = DateTime.now();
    final testNotificationTime = now.add(const Duration(seconds: 10));

    notificationService.schedulePrayerNotification(
      id: 1001,
      title: 'Test Notification',
      body: 'This is a test notification scheduled 10 seconds from now',
      dateTime: testNotificationTime,
    );

    Get.snackbar(
      'Test Notification Scheduled',
      'An notification will appear after 10 seconds',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    print('Test notification scheduled');
  }
}
