import 'dart:async';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateController extends GetxController {
  var formattedDate = ''.obs;
  var hijriDate = ''.obs;
  var gregorianDate = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _updateDate();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDate();
    });
  }

  void _updateDate() {
    HijriCalendar.setLocal('ar');
    var hijri = HijriCalendar.now();
    var day = DateTime.now();
    var format = DateFormat(' d MMM yyyy', "ar");
    var formattedGregorian = format.format(day);
    var forrmmat = DateFormat('hh:mm EEE', 'ar');
    var formattedTime = forrmmat.format(DateTime.now());

    hijriDate.value = hijri.toFormat("dd MMMM yyyy");
    formattedDate.value = formattedTime;
    gregorianDate.value = formattedGregorian;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
