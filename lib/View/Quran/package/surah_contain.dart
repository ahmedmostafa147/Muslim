import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/View/Quran/favourit_bookmark/bookmark.dart';
import 'package:muslim/View/Quran/favourit_bookmark/fav.dart';
import 'package:muslim/View/Quran/package/basmallah.dart';
import 'package:muslim/View/Quran/package/tafseer_package.dart';
import 'package:quran/quran.dart' as quran;

import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class SurahContainList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> keys = [];
  final surahController = Get.put(SurahControllerSave());

  SurahContainList({super.key}) {
    // Generate keys for the number of verses in the surah
    final arguments = Get.arguments;
    final surahVerseCount = arguments['surahVerseCount'] as int;
    keys.addAll(List.generate(surahVerseCount, (index) => GlobalKey()));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final surahIndex = arguments['surahIndex'] as int;
    final surahVerseCount = arguments['surahVerseCount'] as int;
    final surahName = arguments['surahName'] as String;

    surahController.setSurah(surahIndex);

    // استماع لتغير الآية الحالية وتحريك الشاشة تلقائيًا
    surahController.verseNumber.listen((verseNumber) {
      if (verseNumber > 0 && verseNumber <= keys.length) {
        // الحصول على RenderBox للعنصر
        final keyContext = keys[verseNumber - 1].currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero,
              ancestor: context.findRenderObject() as RenderObject);
          double yOffset = scrollController.offset +
              position.dy -
              (context.size!.height / 2) +
              (box.size.height / 2);

          // تحريك الشاشة بناءً على موقع العنصر
          scrollController.animateTo(
            yOffset.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => TafseerScreenPackage(), arguments: surahIndex);
            },
            icon: const Icon(Icons.book),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => BookmarkListScreen(onVerseTap: scrollToVerse));
            },
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => FavoriteListScreen());
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: surahVerseCount,
              itemBuilder: (context, verseIndex) {
                final verseNumber = verseIndex + 1;
                final verseText = quran.getVerse(surahIndex, verseNumber,
                    verseEndSymbol: true);
                final verseText1 =
                    quran.getVerseTranslation(surahIndex, verseNumber);
                final bool isBismillahRequired =
                    surahIndex != 1 && surahIndex != 9 && verseNumber == 1;

                return Column(
                  key: keys[verseIndex],
                  children: [
                    if (isBismillahRequired) const Basmallah(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(7.w, 10.w, 7.w, 10.w),
                      child: Obx(() => Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5),
                              color: surahController.verseNumber.value ==
                                      verseNumber
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StackOfNumber(
                                        surahIndex: verseNumber.toString()),
                                    RowIconVerse(
                                      verseNumber: verseNumber,
                                      surahNumber: surahIndex,
                                      verseTextForSurah: verseText,
                                      surahName: surahName,
                                      surahVerseCount: surahVerseCount,
                                      onHeadphonePressed: () {
                                        surahController.setVerse(verseNumber);
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(7.w, 15.w, 7.w, 15.w),
                                  child: VerseText(
                                      verseText1: verseText1,
                                      verseText: verseText),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scrollToVerse(int surahIndex, int verseNumber) {
    if (verseNumber > 0 && verseNumber <= keys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final keyContext = keys[verseNumber - 1].currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero,
              ancestor: keys[0].currentContext?.findRenderObject());
          double yOffset = scrollController.offset +
              position.dy -
              (scrollController.position.viewportDimension / 2) +
              (box.size.height / 2);

          scrollController.animateTo(
            yOffset.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          // Temporarily highlight the verse
          highlightVerse(verseNumber);
        }
      });
    }
  }

  void highlightVerse(int verseNumber) {
    surahController.setVerse(verseNumber);
    Future.delayed(Duration(seconds: 2), () {
      surahController.setVerse(0);
    });
  }
}
