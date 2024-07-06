import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
