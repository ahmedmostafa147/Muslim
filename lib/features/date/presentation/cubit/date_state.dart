import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

class DateState extends Equatable {
  final DateTime gregorianDate;
  final HijriCalendar hijriDate;

  DateState({
    DateTime? gregorianDate,
    HijriCalendar? hijriDate,
  })  : gregorianDate = gregorianDate ?? DateTime.now(),
        hijriDate = hijriDate ?? HijriCalendar.now();

  DateState copyWith({
    DateTime? gregorianDate,
    HijriCalendar? hijriDate,
  }) {
    return DateState(
      gregorianDate: gregorianDate ?? this.gregorianDate,
      hijriDate: hijriDate ?? this.hijriDate,
    );
  }

  @override
  List<Object?> get props => [gregorianDate, hijriDate];
}
