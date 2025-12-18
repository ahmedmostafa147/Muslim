import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/prayer_time.dart';
import 'location.dart';
import 'notification.dart';

class PrayerTimesController extends GetxController {
  var calculationMethod = '5'.obs; // Egyptian method as default
  var madhab = 'Shafi'.obs;
  var selectedDate = DateTime.now().obs;
  var prayerTimes = Rxn<PrayerTimes>();
  var nextPrayer = ''.obs;
  var nextPrayerName = ''.obs;
  var timeRemaining = ''.obs;
  Timer? _timer;
  SharedPreferences? prefs;

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadPrayerTimesFromCache();
    updatePrayerTimes();
  }

  Future<void> fetchPrayerTimes(
      double latitude, double longitude, DateTime date) async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/calendar/${date.year}/${date.month}?latitude=$latitude&longitude=$longitude&method=${calculationMethod.value}&school=${madhab.value == 'Shafi' ? '0' : '1'}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        prayerTimes.value = PrayerTimes.fromJson(data[date.day - 1]['timings']);

        // تنسيق الأوقات
        prayerTimes.value = PrayerTimes(
          fajr: _formatTime(prayerTimes.value!.fajr),
          dhuhr: _formatTime(prayerTimes.value!.dhuhr),
          asr: _formatTime(prayerTimes.value!.asr),
          maghrib: _formatTime(prayerTimes.value!.maghrib),
          isha: _formatTime(prayerTimes.value!.isha),
          sunrise: _formatTime(prayerTimes.value!.sunrise),
          sunset: _formatTime(prayerTimes.value!.sunset),
          imsak: _formatTime(prayerTimes.value!.imsak),
          midnight: _formatTime(prayerTimes.value!.midnight),
        );

        savePrayerTimesToCache(latitude, longitude);

        if (notificationController.isNotificationOn.value) {
          notificationController.schedulePrayerNotifications();
        }

        calculateNextPrayer(); // Calculate next prayer time after fetching
      } else {
        throw Exception('Failed to load prayer times');
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  String _formatTime(String time) {
    try {
      final DateTime dateTime = DateFormat('HH:mm').parse(time.substring(0, 5));
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  Future<void> updatePrayerTimes() async {
    LocationController locationController = Get.find<LocationController>();
    var locationData = await locationController.getLocationFromPreferences();
    var latitude = locationData['latitude']!;
    var longitude = locationData['longitude']!;

    if (_isLocationChanged(latitude, longitude)) {
      clearOldCache();
    }

    await fetchPrayerTimes(latitude, longitude, selectedDate.value);
  }

  bool _isLocationChanged(double newLatitude, double newLongitude) {
    if (prefs == null) return false;

    var cachedData = prefs!.getString('cachedPrayerTimes');
    if (cachedData != null) {
      var data = json.decode(cachedData);
      var cachedLatitude = data['latitude'];
      var cachedLongitude = data['longitude'];

      return newLatitude != cachedLatitude || newLongitude != cachedLongitude;
    }

    return true;
  }

  void clearOldCache() {
    if (prefs != null) {
      prefs!.remove('cachedPrayerTimes');
    }
  }

  void savePrayerTimesToCache(double latitude, double longitude) {
    if (prefs == null) return;

    var data = {
      'prayerTimes': prayerTimes.value!.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    prefs!.setString('cachedPrayerTimes', json.encode(data));
  }

  void loadPrayerTimesFromCache() {
    if (prefs == null) return;

    var cachedData = prefs!.getString('cachedPrayerTimes');
    if (cachedData != null) {
      var data = json.decode(cachedData);
      var cacheTimestamp =
          DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
      var currentTime = DateTime.now();

      // تحميل البيانات فقط إذا كانت لم تتعدى الشهر
      if (currentTime.difference(cacheTimestamp).inDays <= 30) {
        prayerTimes.value = PrayerTimes.fromJson(data['prayerTimes']);
        calculateNextPrayer(); // Calculate next prayer time after loading from cache
      }
    }
  }

  void calculateNextPrayer() {
    if (prayerTimes.value == null) return;

    final now = DateTime.now();
    final prayers = [
      {'name': 'Fajr', 'time': prayerTimes.value!.fajr},
      {'name': 'Dhuhr', 'time': prayerTimes.value!.dhuhr},
      {'name': 'Asr', 'time': prayerTimes.value!.asr},
      {'name': 'Maghrib', 'time': prayerTimes.value!.maghrib},
      {'name': 'Isha', 'time': prayerTimes.value!.isha},
    ];

    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = DateFormat('hh:mm a').parse(prayers[i]['time']!);
      final prayerDateTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

      if (now.isBefore(prayerDateTime)) {
        nextPrayerTime = prayerDateTime;
        nextPrayerName = prayers[i]['name'];
        break;
      }
    }

    if (nextPrayerTime == null) {
      final fajrTime = DateFormat('hh:mm a').parse(prayerTimes.value!.fajr);
      nextPrayerTime = DateTime(
          now.year, now.month, now.day + 1, fajrTime.hour, fajrTime.minute);
      nextPrayerName = 'Fajr';
    }

    nextPrayer.value = nextPrayerName!;
    this.nextPrayerName.value = _getLocalizedPrayerName(nextPrayerName);
    _startTimer(nextPrayerTime);
  }

  void _startTimer(DateTime nextPrayerTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final remaining = nextPrayerTime.difference(now);

      if (remaining.isNegative) {
        _timer?.cancel();
        timeRemaining.value = "وقت الصلاة ${nextPrayerName.value}";
      } else {
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes.remainder(60);
        final seconds = remaining.inSeconds.remainder(60);
        timeRemaining.value = '$hours ساعة $minutes دقيقة $seconds ثانية';
      }
    });
  }

  String _getLocalizedPrayerName(String name) {
    switch (name) {
      case 'Fajr':
        return 'الفجر';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return '';
    }
  }

  void incrementDate() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    updatePrayerTimes();
  }

  void decrementDate() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    updatePrayerTimes();
  }

  void changeCalculationMethod(String method) {
    calculationMethod.value = method;
    updatePrayerTimes();
  }

  void changeMadhab(String newMadhab) {
    madhab.value = newMadhab;
    updatePrayerTimes();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    updatePrayerTimes();
  }
}
