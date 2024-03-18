import 'dart:math';
import 'package:Muslim/Controller/location_geo_controller.dart';
import 'package:Muslim/Controller/prayer_time_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constant/doe_verser.dart';

class NotificationService {
  final LocationController locationController = Get.find<LocationController>();
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
        ),
        NotificationChannel(
          channelKey: 'dhuhr_channel',
          channelName: 'الظهر',
          channelDescription: "قناة إشعارات الظهر",
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'asr_channel',
          channelName: 'العصر',
          channelDescription: "قناة إشعارات العصر",
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'maghrib_channel',
          channelName: 'المغرب',
          channelDescription: "قناة إشعارات المغرب",
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'isha_channel',
          channelName: 'العشاء',
          channelDescription: "قناة إشعارات العشاء",
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'azkar_channel',
          channelName: 'الأذكار',
          channelDescription: "قناة إشعارات الأذكار",
          importance: NotificationImportance.High,
        ),
      ],
      debug: true,
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

  Future<void> fajr() async {
    print('fajr' +
        prayerTimesControllerForRow.prayerTimes.value!.fajr.toString());
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'fajr_channel',
          title: 'الفجر',
          body: 'حان الآن موعد صلاة الفجر',
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: prayerTimesControllerForRow.prayerTimes.value!.fajr,
            allowWhileIdle: true,
            repeats: true,
            preciseAlarm: true));
  }

  Future<void> dhuhr() async {
    print('dhuhr' +
        prayerTimesControllerForRow.prayerTimes.value!.dhuhr.toString());
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'dhuhr_channel',
          title: 'الظهر',
          body: 'حان الآن موعد صلاة الظهر',
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: prayerTimesControllerForRow.prayerTimes.value!.dhuhr,
            allowWhileIdle: true,
            repeats: true,
            preciseAlarm: true));
  }

  Future<void> asr() async {
    print(
        'asr' + prayerTimesControllerForRow.prayerTimes.value!.asr.toString());
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'asr_channel',
          title: 'العصر',
          body: 'حان الآن موعد صلاة العصر',
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: prayerTimesControllerForRow.prayerTimes.value!.asr,
            allowWhileIdle: true,
            repeats: true,
            preciseAlarm: true));
  }

  Future<void> maghrib() async {
    print('maghrib' +
        prayerTimesControllerForRow.prayerTimes.value!.maghrib.toString());
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'maghrib_channel',
          title: 'المغرب',
          body: 'حان الآن موعد صلاة المغرب',
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: prayerTimesControllerForRow.prayerTimes.value!.maghrib,
            allowWhileIdle: true,
            repeats: true,
            preciseAlarm: true));
  }

  Future<void> isha() async {
    print('isha' +
        prayerTimesControllerForRow.prayerTimes.value!.isha.toString());
    final random = Random();
    final id = random.nextInt(100000) + 1;
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'isha_channel',
          title: 'العشاء',
          body: 'حان الآن موعد صلاة العشاء',
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: prayerTimesControllerForRow.prayerTimes.value!.isha,
            allowWhileIdle: true,
            repeats: true,
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
