import '../../../../Models/bookmark_quran.dart';
import '../../../../Models/favorite_quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;

import 'basmala_card.dart';
import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class SurahContainList extends StatefulWidget {
  final int surahIndex;
  final int surahVerseCount;
  final String surahName;

  const SurahContainList({
    Key? key,
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
  }) : super(key: key);

  @override
  State<SurahContainList> createState() => _SurahContainState();
}

class _SurahContainState extends State<SurahContainList> {
  FavoriteManager favoriteManager = FavoriteManager();
  BookmarkManager bookmarkManager = BookmarkManager();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        centerTitle: true,
      ),
      body: ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: widget.surahVerseCount,
          itemBuilder: (context, verseIndex) {
            final verseNumber = verseIndex + 1;
            final verseText = quran.getVerse(widget.surahIndex, verseNumber,
                verseEndSymbol: true);
            final verseText1 = quran.getVerseTranslation(
              widget.surahIndex,
              verseNumber,
            );

            final bool isBismillahRequired = widget.surahIndex != 1 &&
                widget.surahIndex != 9 &&
                verseNumber == 1;

            return Column(children: [
              if (isBismillahRequired) const BasmalaCardSurah(),
              Padding(
                padding: EdgeInsets.fromLTRB(7.w, 10.w, 7.w, 10.w),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
              
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                  ),
                  child: (Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StackOfNumber(
                            surahIndex: verseNumber.toString(),
                          ),
                          RowIconVerse(
                            bookManger: bookmarkManager,
                            favoriteManager: favoriteManager,
                            verseNumber: verseNumber,
                            surahNumber: widget.surahIndex,
                            verseTextForSurah: verseText,
                            surahName: widget.surahName,
                            surahVerseCount: widget.surahVerseCount,
                            onTapBookmark: () async {
                              BookmarkItem bookmarkItem = BookmarkItem(
                                surahIndex: widget.surahIndex,
                                verseNumber: verseNumber,
                                surahName: widget.surahName,
                                verseText: verseText,
                                surahVerseCount: widget.surahVerseCount,
                              );
                            },
                            onTapFavorite: () async {
                              FavoriteItem favoriteItem = FavoriteItem(
                                surahIndex: widget.surahIndex,
                                verseNumber: verseNumber,
                                surahName: widget.surahName,
                                verseText: verseText,
                                surahVerseCount: widget.surahVerseCount,
                              );
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
                  )),
                ),
              ),
            ]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final versesCount = widget.surahVerseCount;
          final verseDuration = Duration(seconds: versesCount * 10);
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: verseDuration,
            curve: Curves.linear,
          );
        },
        child: const Text("تمرير"),
      ),
    );
  }
}
