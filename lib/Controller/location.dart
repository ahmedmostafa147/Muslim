import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  var address = 'اضغط هنا لتحديد الموقع الحالي'.obs;
  var latitude = 30.007413.obs;
  var longitude = 31.4913182.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getLocationFromPreferences();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        address.value = 'Permission denied';
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        address.value = 'Permission denied';
        return Future.error('Location permissions are permanently denied');
      }
      setLocaleIdentifier("ar_SA");

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      address.value = "${place.locality} ${place.country}";

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      await _saveLocationData(
          address.value, position.latitude, position.longitude);

      Get.snackbar('نجح', 'تم تحديد الموقع الحالي بنجاح',
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('فشل', 'حدث خطاء اثناء تحديد الموقع الحالي',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      address.value = 'اضغط مره اخري لتحديد الموقع الحالي';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveLocationData(
      String address, double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('address', address);
    prefs.setDouble('latitude', latitude);
    prefs.setDouble('longitude', longitude);
  }

  Future<void> _getLocationFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedAddress =
        prefs.getString('address') ?? 'اضغط هنا لتحديد الموقع الحالي';
    double savedLatitude = prefs.getDouble('latitude') ?? 30.007413;
    double savedLongitude = prefs.getDouble('longitude') ?? 31.4913182;

    address.value = savedAddress;
    latitude.value = savedLatitude;
    longitude.value = savedLongitude;
  }

  Future<Map<String, double>> getLocationFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedLatitude = prefs.getDouble('latitude') ?? 30.007413;
    double savedLongitude = prefs.getDouble('longitude') ?? 31.4913182;

    return {'latitude': savedLatitude, 'longitude': savedLongitude};
  }
}
