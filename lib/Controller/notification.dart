import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  var isNotificationOn = false.obs;
  var isAzkarOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // استرجاع حالة التبديل للإشعارات
    getNotificationStatus();
    // استرجاع حالة التبديل للأذكار
    getAzkarStatus();

    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'prayer_channel',
          channelName: 'Prayer Notifications',
          channelDescription: 'Notification channel for prayer times',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  void getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedValue = prefs.getBool('isNotificationOn');
    isNotificationOn.value = storedValue ?? false;
  }

  void getAzkarStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedValue = prefs.getBool('isAzkarOn');
    isAzkarOn.value = storedValue ?? false;
  }

  void toggleNotification(bool? value) async {
    isNotificationOn.value = value ?? false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationOn', isNotificationOn.value);
    if (isNotificationOn.value) {
      // جدولة الإشعارات
      await schedulePrayerNotifications();
      Get.snackbar(
        'تنبيه',
        'تم تفعيل الإشعارات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // ألغاء جميع الإشعارات
      cancelAllNotifications();
      Get.snackbar(
        'تنبيه',
        'تم تعطيل الإشعارات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleAzkar(bool? value) async {
    isAzkarOn.value = value ?? false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAzkarOn', isAzkarOn.value);
    if (isAzkarOn.value) {
      // جدولة إشعارات الأذكار
      scheduleAzkarNotifications();
    } else {
      // إلغاء جميع إشعارات الأذكار
      cancelAllAzkarNotifications();
    }
  }

  void schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'prayer_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: dateTime),
    );
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

        if (prayerDateTime.isAfter(now)) {
          schedulePrayerNotification(
            id: prayer.hashCode,
            title: 'وقت الصلاة',
            body: 'حان الآن وقت صلاة $prayer',
            dateTime: prayerDateTime,
          );
        }
      });
    }
  }

  void scheduleAzkarNotifications() {
    // جدولة إشعارات الأذكار هنا
  }

  void cancelAllNotifications() {
    AwesomeNotifications().cancelAllSchedules();
  }

  void cancelAllAzkarNotifications() {
    // إلغاء جميع إشعارات الأذكار هنا
  }
}
