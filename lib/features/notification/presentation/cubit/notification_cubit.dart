import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Core/services/notification_services.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final SharedPreferences _prefs;
  late final NotificationService _notificationService;

  NotificationCubit(this._prefs) : super(const NotificationState()) {
    _notificationService = NotificationService();
    _init();
  }

  void _init() {
    final isNotificationOn = _prefs.getBool('isNotificationOn') ?? false;
    final isAzkarOn = _prefs.getBool('isAzkarOn') ?? false;

    emit(state.copyWith(
      status: NotificationStatus.loaded,
      isNotificationOn: isNotificationOn,
      isAzkarOn: isAzkarOn,
    ));
  }

  /// Toggle prayer notifications
  Future<void> toggleNotification(bool? value) async {
    final isOn = value ?? false;
    await _prefs.setBool('isNotificationOn', isOn);

    if (isOn) {
      await schedulePrayerNotifications();
      emit(state.copyWith(
        isNotificationOn: true,
        successMessage: 'تم تفعيل الإشعارات',
      ));
    } else {
      _notificationService.cancelAllNotifications();
      emit(state.copyWith(
        isNotificationOn: false,
        successMessage: 'تم تعطيل الإشعارات',
      ));
    }
  }

  /// Toggle azkar notifications
  Future<void> toggleAzkar(bool? value) async {
    final isOn = value ?? false;
    await _prefs.setBool('isAzkarOn', isOn);
    emit(state.copyWith(isAzkarOn: isOn));
  }

  /// Schedule prayer notifications based on cached prayer times
  Future<void> schedulePrayerNotifications() async {
    final cachedData = _prefs.getString('cachedPrayerTimes');
    if (cachedData == null) return;

    final data = json.decode(cachedData);
    final prayerTimes = data['prayerTimes'];
    final prayerTimesMap = {
      'الفجر': prayerTimes['Fajr'],
      'الظهر': prayerTimes['Dhuhr'],
      'العصر': prayerTimes['Asr'],
      'المغرب': prayerTimes['Maghrib'],
      'العشاء': prayerTimes['Isha'],
    };

    for (final entry in prayerTimesMap.entries) {
      final prayer = entry.key;
      final time = entry.value;

      final prayerTime = DateFormat('hh:mm a').parse(time);
      final now = DateTime.now();
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

      _notificationService.schedulePrayerNotification(
        id: prayer.hashCode,
        title: 'وقت الصلاة',
        body: 'حان الآن وقت صلاة $prayer',
        dateTime: prayerDateTime,
      );
    }
  }

  /// Cancel all notifications
  void cancelAllNotifications() {
    _notificationService.cancelAllNotifications();
  }

  /// Clear messages
  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }
}
