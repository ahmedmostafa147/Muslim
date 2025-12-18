import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';
import 'prayer_times_state.dart';

@injectable
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesRepository _repository;
  final LocationCubit _locationCubit;
  final NotificationCubit _notificationCubit;
  Timer? _timer;

  PrayerTimesCubit(
    this._repository,
    this._locationCubit,
    this._notificationCubit,
  ) : super(PrayerTimesState());

  /// Initialize cubit - load from cache and fetch new data
  Future<void> init() async {
    // Try loading from cache first
    final cached = await _repository.getCachedPrayerTimes();
    if (cached != null) {
      emit(state.copyWith(
        status: PrayerTimesStatus.loaded,
        prayerTimes: cached,
      ));
      _calculateNextPrayer();
    }

    // Then fetch fresh data
    await updatePrayerTimes();
  }

  /// Fetch prayer times from API
  Future<void> fetchPrayerTimes(double latitude, double longitude) async {
    emit(state.copyWith(status: PrayerTimesStatus.loading, clearError: true));

    try {
      final prayerTimes = await _repository.fetchPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: state.selectedDate,
        calculationMethod: state.calculationMethod,
        madhab: state.madhab,
      );

      // Cache the results
      await _repository.cachePrayerTimes(prayerTimes, latitude, longitude);

      emit(state.copyWith(
        status: PrayerTimesStatus.loaded,
        prayerTimes: prayerTimes,
      ));

      // Schedule notifications if enabled
      if (_notificationCubit.state.isNotificationOn) {
        _notificationCubit.schedulePrayerNotifications();
      }

      _calculateNextPrayer();
    } catch (e) {
      emit(state.copyWith(
        status: PrayerTimesStatus.error,
        errorMessage: 'فشل في تحميل مواقيت الصلاة',
      ));
    }
  }

  /// Update prayer times based on current location
  Future<void> updatePrayerTimes() async {
    final location = _locationCubit.state.location;

    // Check if location changed and clear old cache
    if (await _repository.isLocationChanged(
        location.latitude, location.longitude)) {
      await _repository.clearCache();
    }

    await fetchPrayerTimes(location.latitude, location.longitude);
  }

  /// Calculate next prayer time and start countdown
  void _calculateNextPrayer() {
    if (state.prayerTimes == null) return;

    final now = DateTime.now();
    final prayers = [
      {'name': 'Fajr', 'localName': 'الفجر', 'time': state.prayerTimes!.fajr},
      {'name': 'Dhuhr', 'localName': 'الظهر', 'time': state.prayerTimes!.dhuhr},
      {'name': 'Asr', 'localName': 'العصر', 'time': state.prayerTimes!.asr},
      {
        'name': 'Maghrib',
        'localName': 'المغرب',
        'time': state.prayerTimes!.maghrib
      },
      {'name': 'Isha', 'localName': 'العشاء', 'time': state.prayerTimes!.isha},
    ];

    DateTime? nextPrayerTime;
    String? nextPrayerName;
    String? nextPrayerLocalName;

    for (final prayer in prayers) {
      final prayerTime = DateFormat('hh:mm a').parse(prayer['time']!);
      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        prayerTime.hour,
        prayerTime.minute,
      );

      if (now.isBefore(prayerDateTime)) {
        nextPrayerTime = prayerDateTime;
        nextPrayerName = prayer['name'];
        nextPrayerLocalName = prayer['localName'];
        break;
      }
    }

    // If no more prayers today, next is Fajr tomorrow
    if (nextPrayerTime == null) {
      final fajrTime = DateFormat('hh:mm a').parse(state.prayerTimes!.fajr);
      nextPrayerTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
        fajrTime.hour,
        fajrTime.minute,
      );
      nextPrayerName = 'Fajr';
      nextPrayerLocalName = 'الفجر';
    }

    emit(state.copyWith(
      nextPrayer: nextPrayerName,
      nextPrayerName: nextPrayerLocalName,
    ));

    _startTimer(nextPrayerTime);
  }

  /// Start countdown timer
  void _startTimer(DateTime nextPrayerTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final remaining = nextPrayerTime.difference(now);

      if (remaining.isNegative) {
        _timer?.cancel();
        emit(state.copyWith(
          timeRemaining: "وقت الصلاة ${state.nextPrayerName}",
        ));
        // Recalculate for next prayer
        Future.delayed(const Duration(seconds: 5), _calculateNextPrayer);
      } else {
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes.remainder(60);
        final seconds = remaining.inSeconds.remainder(60);
        emit(state.copyWith(
          timeRemaining: '$hours ساعة $minutes دقيقة $seconds ثانية',
        ));
      }
    });
  }

  /// Increment selected date
  void incrementDate() {
    emit(state.copyWith(
      selectedDate: state.selectedDate.add(const Duration(days: 1)),
    ));
    updatePrayerTimes();
  }

  /// Decrement selected date
  void decrementDate() {
    emit(state.copyWith(
      selectedDate: state.selectedDate.subtract(const Duration(days: 1)),
    ));
    updatePrayerTimes();
  }

  /// Change calculation method
  void changeCalculationMethod(String method) {
    emit(state.copyWith(calculationMethod: method));
    updatePrayerTimes();
  }

  /// Change madhab
  void changeMadhab(String madhab) {
    emit(state.copyWith(madhab: madhab));
    updatePrayerTimes();
  }

  /// Change selected date
  void changeDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    updatePrayerTimes();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
