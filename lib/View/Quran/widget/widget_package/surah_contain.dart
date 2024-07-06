import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/View/Quran/screen/book/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    super.key,
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
  });

  @override
  State<SurahContainList> createState() => _SurahContainState();
}

class _SurahContainState extends State<SurahContainList> {
  bool isListView = true;

  @override
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.image : Icons.format_list_bulleted),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
      ),
      body: isListView
          ? buildListView(scrollController)
          : QuranImagesScreen(initialSurahIndex: widget.surahIndex),
    );
  }

  Widget buildListView(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      itemCount: widget.surahVerseCount,
      itemBuilder: (context, verseIndex) {
        final verseNumber = verseIndex + 1;
        final verseText = quran.getVerse(widget.surahIndex, verseNumber,
            verseEndSymbol: true);
        final verseText1 =
            quran.getVerseTranslation(widget.surahIndex, verseNumber);
        final bool isBismillahRequired = widget.surahIndex != 1 &&
            widget.surahIndex != 9 &&
            verseNumber == 1;

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
                          surahNumber: widget.surahIndex,
                          verseTextForSurah: verseText,
                          surahName: widget.surahName,
                          surahVerseCount: widget.surahVerseCount,
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
    );
  }
}
