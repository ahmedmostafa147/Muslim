import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/core/di/injection.dart';
import 'package:muslim/features/quran/presentation/cubit/last_read_cubit.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/quran_audio_cubit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../favourit_bookmark/bookmark.dart';
import '../favourit_bookmark/fav.dart';
import 'audio_player.dart';
import 'recorder.dart';
import 'tafseer_package.dart';
import 'verse_item.dart';

class SurahContainList extends StatelessWidget {
  const SurahContainList({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final surahIndex = arguments['surahIndex'] as int? ?? 1;
    final surahVerseCount = arguments['surahVerseCount'] as int? ?? 7;
    final surahName = arguments['surahName'] as String? ?? 'الفاتحة';
    final versenumberfromlastread =
        arguments['versenumberfromlastread'] as int? ?? 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QuranAudioCubit>()),
        BlocProvider(create: (_) => getIt<LastReadCubit>()),
      ],
      child: _SurahContainView(
        surahIndex: surahIndex,
        surahVerseCount: surahVerseCount,
        surahName: surahName,
        versenumberfromlastread: versenumberfromlastread,
      ),
    );
  }
}

class _SurahContainView extends StatefulWidget {
  final int surahIndex;
  final int surahVerseCount;
  final String surahName;
  final int versenumberfromlastread;

  const _SurahContainView({
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
    required this.versenumberfromlastread,
  });

  @override
  State<_SurahContainView> createState() => _SurahContainViewState();
}

class _SurahContainViewState extends State<_SurahContainView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.versenumberfromlastread > 0 &&
          _itemScrollController.isAttached) {
        _itemScrollController.jumpTo(index: widget.versenumberfromlastread);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              physics: const BouncingScrollPhysics(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: widget.surahVerseCount,
              itemBuilder: (context, verseIndex) {
                return VerseItem(
                  surahIndex: widget.surahIndex,
                  verseIndex: verseIndex,
                  surahName: widget.surahName,
                  surahVerseCount: widget.surahVerseCount,
                );
              },
            ),
          ),
          RecordingWidget(
            onRecordingComplete: (filePath) {
              debugPrint("تم تسجيل الصوت وحفظه في: $filePath");
            },
          ),
          const AudioPlayerWidget(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.surahName),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TafseerScreenPackage(surahIndex: widget.surahIndex),
              ),
            );
          },
          icon: const Icon(Icons.book),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookmarkListScreen()),
            );
          },
          icon: const Icon(Icons.bookmark),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteListScreen()),
            );
          },
          icon: const Icon(Icons.favorite),
        ),
      ],
    );
  }
}
