import 'package:equatable/equatable.dart';
import '../../domain/entities/prayer_times_entity.dart';

enum PrayerTimesStatus { initial, loading, loaded, error }

class PrayerTimesState extends Equatable {
  final PrayerTimesStatus status;
  final PrayerTimesEntity? prayerTimes;
  final String nextPrayer;
  final String nextPrayerName;
  final String timeRemaining;
  final DateTime selectedDate;
  final String calculationMethod;
  final String madhab;
  final String? errorMessage;

  PrayerTimesState({
    this.status = PrayerTimesStatus.initial,
    this.prayerTimes,
    this.nextPrayer = '',
    this.nextPrayerName = '',
    this.timeRemaining = '',
    DateTime? selectedDate,
    this.calculationMethod = '5', // Egyptian method
    this.madhab = 'Shafi',
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  PrayerTimesState copyWith({
    PrayerTimesStatus? status,
    PrayerTimesEntity? prayerTimes,
    String? nextPrayer,
    String? nextPrayerName,
    String? timeRemaining,
    DateTime? selectedDate,
    String? calculationMethod,
    String? madhab,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PrayerTimesState(
      status: status ?? this.status,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      selectedDate: selectedDate ?? this.selectedDate,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        prayerTimes,
        nextPrayer,
        nextPrayerName,
        timeRemaining,
        selectedDate,
        calculationMethod,
        madhab,
        errorMessage,
      ];
}
