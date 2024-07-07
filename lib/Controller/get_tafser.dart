import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:muslim/Models/load_quran.dart';

class QuranController extends GetxController {
  var quranData = Quran(data: []).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuran();
  }

  Future<void> loadQuran() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/database/quran.json');
      final jsonResponse = json.decode(jsonString);
      quranData.value = Quran.fromJson(jsonResponse);
      if (quranData.value.data.isEmpty) {
        throw Exception('No data found in quran.json');
      }
    } catch (e) {
      throw Exception('Error loading Quran data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Datum? getSurahByPage(int page) {
    for (var surah in quranData.value.data) {
      if (surah.ayahs.any((ayah) => ayah.page == page)) {
        return surah;
      }
    }
    return null;
  }

  List<Ayah>? getAyahsByPage(int page) {
    List<Ayah> ayahs = [];
    for (var surah in quranData.value.data) {
      ayahs.addAll(surah.ayahs.where((ayah) => ayah.page == page));
    }
    return ayahs.isNotEmpty ? ayahs : null;
  }

  Datum? getSurahByNumber(int number) {
    for (var surah in quranData.value.data) {
      if (surah.number == number) {
        return surah;
      }
    }
    return null;
  }

}
