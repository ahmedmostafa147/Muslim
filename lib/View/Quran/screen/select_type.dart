import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/constant/images.dart';
import 'package:muslim/View/Quran/screen/book/view.dart';
import 'package:muslim/View/Quran/widget/widget_package/surah_contain.dart';

class SelectTypeReading extends StatelessWidget {
  const SelectTypeReading({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final surahIndex = arguments['surahIndex'] as int;
    final surahVerseCount = arguments['surahVerseCount'] as int;
    final surahName = arguments['surahName'] as String;
    final pageNumber = arguments['pageNumber'] as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Type of Reading'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Container for List Icon
            InkWell(
              onTap: () {
                Get.to(() => const SurahContainList(), arguments: {
                  'surahIndex': surahIndex,
                  'surahVerseCount': surahVerseCount,
                  'surahName': surahName
                });
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage(Assets.imagesSmartphone),
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            // Container for Book Icon
            InkWell(
              onTap: () {
                Get.to(() => QuranImagesScreen(), arguments: pageNumber);
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage(Assets.imagesQuranforselecte),
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
