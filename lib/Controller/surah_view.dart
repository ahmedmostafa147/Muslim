import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranViewController extends GetxController {
  final String baseUrl =
      'https://raw.githubusercontent.com/Mohamed-Nagdy/Quran-App-Data/main/quran_images/';
  var surahNames =
      List<String>.generate(604, (index) => '${index + 1}.png').obs;

  String getSurahImageUrl(String surahName) {
    return '$baseUrl$surahName';
  }

  void prefetchImages(int startIndex, int count) {
    for (int i = startIndex; i < startIndex + count; i++) {
      if (i < surahNames.length) {
        final imageUrl = getSurahImageUrl(surahNames[i]);
        precacheImage(NetworkImage(imageUrl), Get.context!);
      }
    }
  }
}
