import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/services/shared_perferance.dart';
import 'package:quran/quran.dart' as quran;

class SurahController extends GetxController {
  var allSurahNames = <String>[].obs;
  var filteredSurahNames = <String>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    allSurahNames.value = List.generate(
      quran.totalSurahCount,
      (index) => quran.getSurahNameArabic(index + 1),
    );
    filteredSurahNames.value = allSurahNames;
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      var dummyListData =
          allSurahNames.where((item) => item.contains(query)).toList();
      filteredSurahNames.value = dummyListData;
    } else {
      filteredSurahNames.value = allSurahNames;
    }
  }
}


class SurahControllerSave extends GetxController {
  var surahNumber = 0.obs;
  var verseNumber = 0.obs;
  var pageNumber = 0.obs;

  void setSurah(int surah) {
    surahNumber.value = surah;
    StorageService.setLastReadSurah(surah);
  }

  void setVerse(int verse) {
    verseNumber.value = verse;
    StorageService.setLastReadVerse(verse);
  }

  void setPage(int page) {
    pageNumber.value = page;
    StorageService.setLastReadPage(page);
  }

  Future<void> loadLastRead() async {
    surahNumber.value = (await StorageService.getLastReadSurah()) ?? 0;
    verseNumber.value = (await StorageService.getLastReadVerse()) ?? 0;
    pageNumber.value = (await StorageService.getLastReadPage()) ?? 0;
  }
}
