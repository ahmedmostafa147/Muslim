import 'dart:async';
import 'location_geo_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

class PrayerTimesControllerForRow extends GetxController {
  var prayerTimes = Rx<PrayerTimes?>(null);
  final LocationController locationController = Get.put<LocationController>(
    LocationController(),
  );

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
    ever(locationController.latitude, (_) => fetchPrayerTimes());
    ever(locationController.longitude, (_) => fetchPrayerTimes());
  }

  Future<void> fetchPrayerTimes() async {
    var myCoordinates = Coordinates(
        locationController.latitude.value, locationController.longitude.value);
    var params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    try {
      prayerTimes.value = PrayerTimes.today(myCoordinates, params);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class PrayerTimesControllerForColumn extends GetxController {
  var prayerTimes = Rx<PrayerTimes?>(null);
  var nextPrayer = Prayer.fajr.obs;
  var nextPrayerName = 'الفجر'.obs;
  var arabicNextPrayerName = 'الفجر'.obs;
  var nextPrayerTime = DateTime.now().obs;
  var timeRemaining = const Duration(seconds: 0).obs;
  late Timer timer;
  LocationController locationController = Get.find<LocationController>();

  final prayerNameArabicMap = {
    'Prayer.none': 'الفجر',
    'Prayer.fajr': 'الفجر',
    'Prayer.sunrise': 'الشروق',
    'Prayer.dhuhr': 'الظهر',
    'Prayer.asr': 'العصر',
    'Prayer.maghrib': 'المغرب',
    'Prayer.isha': 'العشاء',
  };

  @override
  void onInit() {
    super.onInit();
    startCountdown();
    fetchPrayerTimes();
    ever(locationController.latitude, (_) => fetchPrayerTimes());
    ever(locationController.longitude, (_) => fetchPrayerTimes());
  }

  Future<void> fetchPrayerTimes() async {
    var myCoordinates = Coordinates(
        locationController.latitude.value, locationController.longitude.value);
    var params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    prayerTimes.value = PrayerTimes.today(myCoordinates, params);
    calculateNextPrayer();
  }

  void calculateNextPrayer() {
    if (prayerTimes.value != null) {
      nextPrayer.value = prayerTimes.value!.nextPrayer();

      if (nextPrayer.value == Prayer.none) {
        LocationController locationController = Get.find<LocationController>();
        var myCoordinates = Coordinates(
          locationController.latitude.value,
          locationController.longitude.value,
        );
        var params = CalculationMethod.egyptian.getParameters();
        params.madhab = Madhab.shafi;

        DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
        DateComponents dateComponents =
            DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);

        PrayerTimes tomorrowPrayerTimes = PrayerTimes(
          myCoordinates,
          dateComponents,
          params,
        );

        nextPrayer.value = tomorrowPrayerTimes.nextPrayer();

        nextPrayerTime.value =
            tomorrowPrayerTimes.timeForPrayer(nextPrayer.value)!;
      } else {
        nextPrayer.value = prayerTimes.value!.nextPrayer();
        nextPrayerTime.value =
            prayerTimes.value!.timeForPrayer(nextPrayer.value)!;
      }

      nextPrayerName.value = nextPrayer.value.toString();
      arabicNextPrayerName.value = prayerNameArabicMap[nextPrayerName]!;
      updateRemainingTime();
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateRemainingTime();
    });
  }

  void updateRemainingTime() {
    var now = DateTime.now();
    var difference = nextPrayerTime.value.difference(now);
    if (difference.inSeconds > 0) {
      timeRemaining.value = difference;
    }
  }

  String formatRemainingTime(Duration remainingTime) {
    try {
      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes.remainder(60);
      int seconds = remainingTime.inSeconds.remainder(60);

      String formattedTime = DateFormat.Hms('ar')
          .format(DateTime(0, 0, 0, hours, minutes, seconds));

      return formattedTime;
    } catch (e) {
      return '';
    }
  }
}
