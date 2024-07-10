import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/sound_quran_package.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/View/Quran/favourit_bookmark/bookmark.dart';
import 'package:muslim/View/Quran/favourit_bookmark/fav.dart';
import 'package:muslim/View/Quran/package/audio_player.dart';
import 'package:muslim/View/Quran/package/tafseer_package.dart';
import 'package:muslim/View/Quran/package/verse_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SurahContainList extends StatelessWidget {
  const SurahContainList({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemScrollController itemScrollController =
        Get.put<QuranicVersePlayerController>(
      QuranicVersePlayerController(),
    ).itemScrollController;
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    final RxInt lastVisibleVerse = (-1).obs;
    final arguments = Get.arguments;
    final surahIndex = arguments['surahIndex'] as int;
    final surahVerseCount = arguments['surahVerseCount'] as int;
    final surahName = arguments['surahName'] as String;
    final versenumberfromlastread = arguments['versenumberfromlastread'] as int;
    final quranController = Get.put(QuranicVersePlayerController());
    final surahController = Get.put(SurahControllerSave());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (versenumberfromlastread > 0) {
        itemScrollController.jumpTo(index: versenumberfromlastread);
      }
    });
    return Scaffold(
      appBar: _buildAppBar(surahName, surahIndex),
      body: Column(
        children: [
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              physics: const BouncingScrollPhysics(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: surahVerseCount,
              itemBuilder: (context, verseIndex) {
                return VerseItem(
                  context: context,
                  surahIndex: surahIndex,
                  verseIndex: verseIndex,
                  surahName: surahName,
                  surahVerseCount: surahVerseCount,
                  quranController: quranController,
                  surahController: surahController,
                  lastVisibleVerse: lastVisibleVerse,
                );
              },
            ),
          ),
          AudioPlayerWidget(quranController: quranController),
        ],
      ),
    );
  }

  AppBar _buildAppBar(String surahName, int surahIndex) {
    return AppBar(
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
            Get.to(() => const BookmarkListScreen());
          },
          icon: const Icon(Icons.bookmark),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => const FavoriteListScreen());
          },
          icon: const Icon(Icons.favorite),
        ),
      ],
    );
  }
}
