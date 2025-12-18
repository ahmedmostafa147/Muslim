import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Core/services/shared_perferance.dart';
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
  var surahName = ''.obs;
  var surahNumber = 0.obs;
  var verseNumber = 0.obs;
  var pageNumber = 0.obs;
  var lastReadSurahVisible = false.obs;
  var lastReadMode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastRead();
  }

  void setSurah(String surah) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      surahName.value = surah;
      StorageService.setLastReadSurah(surah);
      updateLastReadVisibility();
    });
  }

  void setSurahIndex(int surahIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      surahNumber.value = surahIndex;
      StorageService.setLastReadSurahIndex(surahIndex);
      updateLastReadVisibility();
    });
  }

  void setVerse(int verse) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verseNumber.value = verse;
      StorageService.setLastReadVerse(verse);
      StorageService.setLastReadMode('list');
      lastReadMode.value = 'list';
      updateLastReadVisibility();
    });
  }

  void setPage(int page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageNumber.value = page;
      StorageService.setLastReadPage(page);
      StorageService.setLastReadMode('mushaf');
      lastReadMode.value = 'mushaf';
      updateLastReadVisibility();
    });
  }

  Future<void> loadLastRead() async {
    surahName.value = (await StorageService.getLastReadSurah()) ?? '';
    surahNumber.value = (await StorageService.getLastReadSurahIndex()) ?? 0;
    verseNumber.value = (await StorageService.getLastReadVerse()) ?? 0;
    pageNumber.value = (await StorageService.getLastReadPage()) ?? 0;
    lastReadMode.value = (await StorageService.getLastReadMode()) ?? '';
    updateLastReadVisibility();
  }

  void updateLastReadVisibility() {
    lastReadSurahVisible.value = shouldShowLastRead();
  }

  bool shouldShowLastRead() {
    return (lastReadMode.value == 'list' &&
            surahNumber.value > 0 &&
            verseNumber.value > 0) ||
        (lastReadMode.value == 'mushaf' &&
            surahName.value != '' &&
            pageNumber.value > 0);
  }
}
