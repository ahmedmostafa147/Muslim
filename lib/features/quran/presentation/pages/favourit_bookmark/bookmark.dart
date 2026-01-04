import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/core/constants/themes.dart';
import 'package:muslim/core/di/injection.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/bookmark_cubit.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/bookmark_state.dart';
import 'package:quran/quran.dart' as quran;

import '../package/surah_contain.dart';

class BookmarkListScreen extends StatelessWidget {
  const BookmarkListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookmarkCubit>(),
      child: const _BookmarkListView(),
    );
  }
}

class _BookmarkListView extends StatelessWidget {
  const _BookmarkListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الايات المحفوظة'),
        centerTitle: true,
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          final bookmarks = state.bookmarkedVerses.toList();
          if (bookmarks.isEmpty) {
            return const Center(child: Text('لا يوجد ايات تم حفظها'));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final verseKey = bookmarks[index];
              final parts = verseKey.split(':');
              final surahNumber = int.parse(parts[0]);
              final verseNumber = int.parse(parts[1]);
              final verseText = quran.getVerse(surahNumber, verseNumber,
                  verseEndSymbol: true);
              final surahName = quran.getSurahNameArabic(surahNumber);
              final surahNameEnglish = quran.getSurahName(surahNumber);
              final verseTextTranslation =
                  quran.getVerseTranslation(surahNumber, verseNumber);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SurahContainList(),
                      settings: RouteSettings(arguments: {
                        'surahIndex': surahNumber,
                        'surahVerseCount': quran.getVerseCount(surahNumber),
                        'surahName': surahName,
                        'versenumberfromlastread': verseNumber - 1,
                      }),
                    ),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$surahName - $surahNameEnglish",
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: TextFontType.quranFont,
                            ),
                          ),
                          IconButton.outlined(
                            icon: const Icon(Icons.delete),
                            onPressed: () => context
                                .read<BookmarkCubit>()
                                .toggleBookmark(verseKey),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              verseText,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: TextFontType.quranFont,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                verseTextTranslation,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: TextFontType.notoNastaliqUrduFont,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
