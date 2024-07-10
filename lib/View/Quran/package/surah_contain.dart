import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/sound_quran_package.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/View/Quran/favourit_bookmark/bookmark.dart';
import 'package:muslim/View/Quran/favourit_bookmark/fav.dart';
import 'package:muslim/View/Quran/package/basmallah.dart';
import 'package:muslim/View/Quran/package/tafseer_package.dart';
import 'package:quran/quran.dart' as quran;
import 'package:muslim/View/Reader/widget_Api/seek_bar.dart';
import 'package:muslim/widgets/container_custom.dart';
import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class SurahContainList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> keys = [];

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

    final quranController = Get.put(QuranicVersePlayerController());
    final surahController = Get.put(SurahControllerSave());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      surahController.setSurah(surahName);
      surahController.setSurahIndex(surahIndex);
      surahController.setVerse(1); // Initialize to 0 or the starting verse
      surahController.lastReadMode.value = 'list';
    });

    quranController.currentVerse.listen((verseNumber) {
      _scrollToCurrentVerse(verseNumber, context);
      surahController.setVerse(verseNumber); // Update the last read verse
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
                return _buildVerseItem(context, surahIndex, verseIndex,
                    surahName, surahVerseCount, quranController);
              },
            ),
          ),
          _buildAudioPlayer(quranController, surahController),
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

  Widget _buildVerseItem(
      BuildContext context,
      int surahIndex,
      int verseIndex,
      String surahName,
      int surahVerseCount,
      QuranicVersePlayerController quranController) {
    final verseNumber = verseIndex + 1;
    final verseText =
        quran.getVerse(surahIndex, verseNumber, verseEndSymbol: true);
    final verseText1 = quran.getVerseTranslation(surahIndex, verseNumber);
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
                      color: Theme.of(context).primaryColor, width: 1.5),
                  color: quranController.currentVerse.value == verseNumber
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
                            quranController.setVerse(
                                surahIndex, verseNumber, verseText, surahName);
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
    );
  }

  Widget _buildAudioPlayer(QuranicVersePlayerController quranController,
      SurahControllerSave surahController) {
    return Obx(() {
      if (quranController.isAudioPlayerVisible.value) {
        return CustomContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.outlined(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      quranController.toggleAudioPlayerVisibility();
                    },
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                      'سورة ${quranController.currentSurahName.value} - الآية ${quranController.verseNumber.value}',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10.0.h),
              Obx(() => SeekBar(
                    duration: quranController.duration.value,
                    position: quranController.position.value,
                    bufferedPosition: quranController.bufferedPosition.value,
                    onChanged: (newPosition) {
                      quranController.seek(newPosition);
                    },
                  )),
              SizedBox(height: 10.0.h),
              if (quranController.isLoading.value)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_next_sharp),
                      onPressed: quranController.nextVerse,
                    ),
                    IconButton(
                      icon: Icon(quranController.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: quranController.isPlaying.value
                          ? quranController.pause
                          : quranController.play,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_sharp),
                      onPressed: quranController.previousVerse,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: quranController.play,
                    ),
                    IconButton(
                      icon: Icon(quranController.isRepeating.value
                          ? Icons.repeat_on_sharp
                          : Icons.repeat),
                      onPressed: quranController.isRepeating.value
                          ? quranController.stopRepeat
                          : quranController.repeat,
                    ),
                  ],
                ),
            ],
          ),
        );
      }
      return Container();
    });
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
