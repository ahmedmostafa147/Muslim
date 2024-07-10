import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/bookmark_favourit_cont.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/View/Quran/package/surah_contain.dart';
import 'package:quran/quran.dart' as quran;

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الايات المفضلة'),
        centerTitle: true,
      ),
      body: Obx(() {
        final favorites = favoriteController.getFavoriteVerses();
        if (favorites.isEmpty) {
          return const Center(child: Text("لا يوجد ايات مفضلة"));
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final verseKey = favorites[index];
            final parts = verseKey.split(':');
            final surahNumber = int.parse(parts[0]);
            final verseNumber = int.parse(parts[1]);

            final verseText =
                quran.getVerse(surahNumber, verseNumber, verseEndSymbol: true);
            final surahName = quran.getSurahNameArabic(surahNumber);
            final surahNameEnglish = quran.getSurahName(surahNumber);
            final verseTextTranslation =
                quran.getVerseTranslation(surahNumber, verseNumber);

            return GestureDetector(
              onTap: () {
                Get.to(() => const SurahContainList(), arguments: {
                  'surahIndex': surahNumber,
                  'surahVerseCount': quran.getVerseCount(surahNumber),
                  'surahName': surahName,
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            favoriteController.toggleFavorite(verseKey);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                    SizedBox(
                      height: 20.h,
                    ),
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
      }),
    );
  }
}
