import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/sound_quran_package.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/View/Quran/favourit_bookmark/bookmark.dart';
import 'package:muslim/View/Quran/favourit_bookmark/fav.dart';
import 'package:muslim/View/Quran/package/audio_player.dart';
import 'package:muslim/View/Quran/package/tafseer_package.dart';
import 'package:muslim/View/Quran/package/verse_item.dart';

class SurahContainList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> keys = [];
  final RxInt lastVisibleVerse = (-1).obs;

  SurahContainList({super.key}) {
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
    final versenumberfromlastread = arguments;
    final quranController = Get.put(QuranicVersePlayerController());
    final surahController = Get.put(SurahControllerSave());

    quranController.currentVerse.listen((verseNumber) {
      _scrollToCurrentVerse(verseNumber, context);
    });

    return Scaffold(
      appBar: _buildAppBar(surahName, surahIndex),
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
                return VerseItem(
                    key: keys[verseIndex],
                    context: context,
                    surahIndex: surahIndex,
                    verseIndex: verseIndex,
                    surahName: surahName,
                    surahVerseCount: surahVerseCount,
                    quranController: quranController,
                    surahController: surahController,
                    lastVisibleVerse: lastVisibleVerse);
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
            Get.to(() => BookmarkListScreen(onVerseTap: scrollToVerse));
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

  void scrollToVerse(int surahIndex, int verseNumber) {
    if (verseNumber > 0 && verseNumber <= keys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(verseNumber);
      });
    }
  }

  void _scrollToCurrentVerse(int verseNumber, BuildContext context) {
    if (verseNumber > 0 && verseNumber <= keys.length) {
      final keyContext = keys[verseNumber - 1].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject() as RenderObject);
        double yOffset = scrollController.offset +
            position.dy -
            (context.size!.height / 2) +
            (box.size.height / 2);

        scrollController.animateTo(
          yOffset.clamp(0.0, scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _scrollToVerse(int verseNumber) {
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

      highlightVerse(verseNumber);
    }
  }

  void highlightVerse(int verseNumber) {
    final quranController = Get.find<QuranicVersePlayerController>();
    quranController.currentVerse.value = verseNumber;
    Future.delayed(const Duration(seconds: 2), () {
      quranController.currentVerse.value = 0;
    });
  }
}
