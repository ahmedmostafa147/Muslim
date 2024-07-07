import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quran/quran.dart' as quran;

import 'basmala_card.dart';
import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class SurahContainList extends StatelessWidget {
  final int surahIndex;
  final int surahVerseCount;
  final String surahName;
  final bool isListView;

  const SurahContainList({
    super.key,
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
    this.isListView = true,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
        appBar: AppBar(
          title: Text(surahName),
          centerTitle: true,
        ),
        body: ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: surahVerseCount,
          itemBuilder: (context, verseIndex) {
            final verseNumber = verseIndex + 1;
            final verseText =
                quran.getVerse(surahIndex, verseNumber, verseEndSymbol: true);
            final verseText1 =
                quran.getVerseTranslation(surahIndex, verseNumber);
            final bool isBismillahRequired =
                surahIndex != 1 && surahIndex != 9 && verseNumber == 1;

            return Column(
              children: [
                if (isBismillahRequired) const BasmalaCardSurah(),
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 10.w, 7.w, 10.w),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.5),
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
                              onTapBookmark: () async {
                                // Bookmark handling
                              },
                              onTapFavorite: () async {
                                // Favorite handling
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7.w, 15.w, 7.w, 15.w),
                          child: VerseText(
                            verseText1: verseText1,
                            verseText: verseText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
