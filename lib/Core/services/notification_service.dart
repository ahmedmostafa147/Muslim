import 'dart:math';

import '../../Controller/location_geo_controller.dart';
import '../../Controller/prayer_time_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/doe_verser.dart';

class NotificationService {
  final locationController = Get.find<LocationController>();
  final PrayerTimesControllerForRow prayerTimesControllerForRow =
      Get.find<PrayerTimesControllerForRow>();

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'fajr_channel',
          channelName: 'الفجر',
          channelDescription: "قناة إشعارات الفجر",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'dhuhr_channel',
          channelName: 'الظهر',
          channelDescription: "قناة إشعارات الظهر",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'asr_channel',
          channelName: 'العصر',
          channelDescription: "قناة إشعارات العصر",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'maghrib_channel',
          channelName: 'المغرب',
          channelDescription: "قناة إشعارات المغرب",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'isha_channel',
          channelName: 'العشاء',
          channelDescription: "قناة إشعارات العشاء",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'azkar_channel',
          channelName: 'الأذكار',
          channelDescription: "قناة إشعارات الأذكار",
          importance: NotificationImportance.High,
          ledColor: Colors.teal,
          criticalAlerts: true,
        ),
      ],
    );

    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey('fajr_channel');
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey('dhuhr_channel');
    await AwesomeNotifications().cancelNotificationsByChannelKey('asr_channel');
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey('maghrib_channel');
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey('isha_channel');
  }

  Future<void> cancelNotificationZekr() async {
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey('azkar_channel');
  }

  Future<void> fajr() async {
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'fajr_channel',
          title: 'الفجر',
          body:
              " حان الآن موعد صلاة الفجر حسب ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(prayerTimesControllerForRow.prayerTimes.value!.fajr)} ",
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          hour: prayerTimesControllerForRow.prayerTimes.value!.fajr.hour,
          minute: prayerTimesControllerForRow.prayerTimes.value!.fajr.minute,
          allowWhileIdle: true,
          preciseAlarm: true,
        ));
  }

  Future<void> dhuhr() async {
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'dhuhr_channel',
          title: 'الظهر',
          body:
              " حان الآن موعد صلاة الظهر حسب ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(prayerTimesControllerForRow.prayerTimes.value!.dhuhr)} ",
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            hour: prayerTimesControllerForRow.prayerTimes.value!.dhuhr.hour,
            minute: prayerTimesControllerForRow.prayerTimes.value!.dhuhr.minute,
            allowWhileIdle: true,
            preciseAlarm: true));
  }

  Future<void> asr() async {
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'asr_channel',
          title: 'العصر',
          body:
              " حان الآن موعد صلاة العصر حسب'${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(prayerTimesControllerForRow.prayerTimes.value!.asr)} ",
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            hour: prayerTimesControllerForRow.prayerTimes.value!.asr.hour,
            minute: prayerTimesControllerForRow.prayerTimes.value!.asr.minute,
            allowWhileIdle: true,
            preciseAlarm: true));
  }

  Future<void> maghrib() async {
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'maghrib_channel',
          title: 'المغرب',
          body:
              " حان الآن موعد صلاة المغرب حسب'${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(prayerTimesControllerForRow.prayerTimes.value!.maghrib)} ",
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            hour: prayerTimesControllerForRow.prayerTimes.value!.maghrib.hour,
            minute:
                prayerTimesControllerForRow.prayerTimes.value!.maghrib.minute,
            allowWhileIdle: true,
            preciseAlarm: true));
  }

  Future<void> isha() async {
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'isha_channel',
          title: 'العشاء',
          body:
              " حان الآن موعد صلاة العشاء حسب'${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(prayerTimesControllerForRow.prayerTimes.value!.isha)} ",
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            hour: prayerTimesControllerForRow.prayerTimes.value!.isha.hour,
            minute: prayerTimesControllerForRow.prayerTimes.value!.isha.minute,
            allowWhileIdle: true,
            preciseAlarm: true));
  }

  static Future<void> zekr() async {
    int index = Random().nextInt(StaticVars().smallDo3a2.length - 1);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: index,
        channelKey: 'azkar_channel',
        title: 'الذكر',
        body: StaticVars().smallDo3a2[index],
        wakeUpScreen: true,
        roundedLargeIcon: true,
        category: NotificationCategory.Reminder,
        fullScreenIntent: true,
        criticalAlert: true,
      ),
    );
  }
}
