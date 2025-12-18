import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:injectable/injectable.dart';
import 'date_state.dart';

@injectable
class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateState());

  /// Get current Hijri date
  HijriCalendar getCurrentHijriDate() {
    return state.hijriDate;
  }

  /// Get current Gregorian date
  DateTime getCurrentGregorianDate() {
    return state.gregorianDate;
  }

  /// Update to today's date
  void refreshDate() {
    emit(DateState(
      gregorianDate: DateTime.now(),
      hijriDate: HijriCalendar.now(),
    ));
  }

  /// Set a specific date
  void setDate(DateTime date) {
    emit(DateState(
      gregorianDate: date,
      hijriDate: HijriCalendar.fromDate(date),
    ));
  }
}
