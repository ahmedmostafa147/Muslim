import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constant/doe_verser.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'salah_channel',
            channelName: 'الصلاة',
            channelDescription: "قناة إشعارات الصلاة",
            importance: NotificationImportance.High,
          ),
          NotificationChannel(
            channelKey: 'azkar_channel',
            channelName: 'الأذكار',
            channelDescription: "قناة إشعارات الأذكار",
            importance: NotificationImportance.High,
          ),
        ],
        debug: true);

    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> salah({
    required String title,
    required String body,
    required DateTime date,
  }) async {
    final random = Random();
    final id = random.nextInt(100000) + 1;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'salah_channel',
          title: title,
          body: body,
          wakeUpScreen: true,
          roundedLargeIcon: true,
          category: NotificationCategory.Reminder,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar.fromDate(
            date: date.toLocal(),
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
