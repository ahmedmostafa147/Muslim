import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:visibility_detector/visibility_detector.dart';

import '../../../Controller/sound_quran_package.dart';
import '../../../Controller/surah_search.dart';
import 'basmallah.dart';

import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class VerseItem extends StatelessWidget {
  final BuildContext context;
  final int surahIndex;
  final int verseIndex;
  final String surahName;
  final int surahVerseCount;
  final QuranicVersePlayerController quranController;
  final SurahControllerSave surahController;
  final RxInt lastVisibleVerse;

  const VerseItem({
    super.key,
    required this.context,
    required this.surahIndex,
    required this.verseIndex,
    required this.surahName,
    required this.surahVerseCount,
    required this.quranController,
    required this.surahController,
    required this.lastVisibleVerse,
  });

  @override
  Widget build(BuildContext context) {
    final verseNumber = verseIndex + 1;
    final verseText =
        quran.getVerse(surahIndex, verseNumber, verseEndSymbol: true);
    final verseText1 = quran.getVerseTranslation(surahIndex, verseNumber);
    final bool isBismillahRequired =
        surahIndex != 1 && surahIndex != 9 && verseNumber == 1;

    return VisibilityDetector(
      key: Key(verseNumber.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.0) {
          lastVisibleVerse.value = verseNumber;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            surahController.setSurah(surahName);
            surahController.setSurahIndex(surahIndex);
            surahController.setVerse(lastVisibleVerse.value);
            surahController.lastReadMode.value = 'list';
          });
        }
      },
      child: Column(
        children: [
          if (isBismillahRequired) const Basmallah(),
          Padding(
            padding: EdgeInsets.fromLTRB(7.w, 10.w, 7.w, 10.w),
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1.5),
                    color: quranController.verseNumber.value == verseNumber
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StackOfNumber(surahIndex: verseNumber.toString()),
                          RowIconVerse(
                            verseNumber: verseNumber,
                            surahNumber: surahIndex,
                            verseTextForSurah: verseText,
                            surahName: surahName,
                            surahVerseCount: surahVerseCount,
                            onHeadphonePressed: () {
                              quranController.setVerse(surahIndex, verseNumber,
                                  verseText, surahName);
                              quranController.toggleAudioPlayerVisibility();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 15.w, 7.w, 15.w),
                        child: VerseText(
                            verseText1: verseText1, verseText: verseText),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
