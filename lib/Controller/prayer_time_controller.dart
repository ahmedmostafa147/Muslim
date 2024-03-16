import 'dart:async';
import 'dart:math';
import 'package:Muslim/Controller/location_geo_controller.dart';
import 'package:Muslim/Core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

class PrayerTimesControllerForRow extends GetxController {
  var prayerTimes = Rx<PrayerTimes?>(null); // Initialize as null
  final LocationController locationController = Get.put<LocationController>(
    LocationController(),
  );
  @override
  void onInit() {
    super.onInit();
    // Fetch prayer times initially
    fetchPrayerTimes();

    ever(locationController.latitude, (_) => fetchPrayerTimes());
    ever(locationController.longitude, (_) => fetchPrayerTimes());

    // Schedule prayer notifications
    schedulePrayerNotifications();
  }

  Future<void> fetchPrayerTimes() async {
    var myCoordinates = Coordinates(
        locationController.latitude.value, locationController.longitude.value);
    var params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    try {
      // Fetch prayer times
      prayerTimes.value = PrayerTimes.today(myCoordinates, params);
    } catch (e) {}
  }

  Future<void> schedulePrayerNotifications() async {
    debugPrint(
      "fajr: ${prayerTimes.value!.fajr}",
    );
    debugPrint(
      "dhuhr: ${prayerTimes.value!.dhuhr}",
    );
    debugPrint(
      "asr: ${prayerTimes.value!.asr}",
    );
    debugPrint(
      "maghrib: ${prayerTimes.value!.maghrib}",
    );
    debugPrint(
      "isha: ${prayerTimes.value!.isha}",
    );

    showPrayerNotification(
      title: "صلاة الفجر",
      body:
          " وقت صلاة الفجر حسب  ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(
        prayerTimes.value!.fajr,
      )} ",
      date: prayerTimes.value!.fajr,
    );
    showPrayerNotification(
      title: "صلاة الظهر",
      body:
          " وقت صلاة الظهر حسب   ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(
        prayerTimes.value!.dhuhr,
      )} ",
      date: prayerTimes.value!.dhuhr,
    );
    showPrayerNotification(
      title: "صلاة العصر",
      body:
          " وقت صلاة العصر حسب  ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(
        prayerTimes.value!.asr,
      )}  ",
      date: prayerTimes.value!.asr,
    );
    showPrayerNotification(
      title: "صلاة المغرب",
      body:
          " وقت صلاة المغرب حسب  ${locationController.address.value} في وقت  ${DateFormat.jm("ar").format(
        prayerTimes.value!.maghrib,
      )}  ",
      date: prayerTimes.value!.maghrib,
    );
    showPrayerNotification(
      title: "صلاة العشاء",
      body:
          " وقت صلاة العشاء حسب  ${locationController.address.value}s في وقت  ${DateFormat.jm("ar").format(
        prayerTimes.value!.isha,
      )}  ",
      date: prayerTimes.value!.isha,
    );
  }

  void showPrayerNotification({
    required String title,
    required String body,
    required DateTime date,
  }) {
    NotificationService.salah(
      title: title,
      body: body,
      date: date,
    );
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
    LocationController locationController = Get.find<LocationController>();
    ever(locationController.latitude, (_) => fetchPrayerTimes());
    ever(locationController.longitude, (_) => fetchPrayerTimes());
  }

  Future<void> fetchPrayerTimes() async {
    LocationController locationController = Get.find<LocationController>();

    var myCoordinates = Coordinates(
        locationController.latitude.value, locationController.longitude.value);
    var params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    prayerTimes.value = PrayerTimes.today(myCoordinates, params);
    calculateNextPrayer();
  }

  void calculateNextPrayer() {
    if (prayerTimes.value != null) {
      // الحصول على صلاة اليوم القادم
      nextPrayer.value = prayerTimes.value!.nextPrayer();

      if (nextPrayer.value == Prayer.none) {
        // إذا كانت صلاة اليوم القادم فارغة، يتم الحصول على أوقات الصلاة لليوم التالي
        LocationController locationController = Get.find<LocationController>();
        var myCoordinates = Coordinates(
          locationController.latitude.value,
          locationController.longitude.value,
        );
        var params = CalculationMethod.egyptian.getParameters();
        params.madhab = Madhab.shafi;

        // حساب تاريخ اليوم التالي
        DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
        DateComponents dateComponents =
            DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);

        // الحصول على أوقات الصلاة لليوم التالي
        PrayerTimes tomorrowPrayerTimes = PrayerTimes(
          myCoordinates,
          dateComponents,
          params,
        );

        // تعيين صلاة اليوم التالي
        nextPrayer.value = tomorrowPrayerTimes.nextPrayer();
        // تعيين وقت الصلاة القادمة لليوم التالي
        nextPrayerTime.value =
            tomorrowPrayerTimes.timeForPrayer(nextPrayer.value)!;
      } else {
        // إذا كانت هناك صلاة لليوم الحالي، يتم استخدام الأوقات المحسوبة بالفعل
        nextPrayer.value = prayerTimes.value!.nextPrayer();
        nextPrayerTime.value =
            prayerTimes.value!.timeForPrayer(nextPrayer.value)!;
      }

      // تحديث اسم الصلاة واسمها باللغة العربية
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
