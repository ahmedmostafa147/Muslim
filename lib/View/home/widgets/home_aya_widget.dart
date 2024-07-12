import 'dart:math';
import 'package:muslim/Core/constant/themes.dart';
import '../../Quran/package/row_aya_copy_love_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;

class RandomVerse {
  late int surahNumber;
  late int verseNumber;
  late String verse;

  RandomVerse() {
    surahNumber = Random().nextInt(114) + 1;
    verseNumber = Random().nextInt(quran.getVerseCount(surahNumber)) + 1;
    verse = quran.getVerse(surahNumber, verseNumber);
  }
}

class HomeAyaWidget extends StatelessWidget {
  const HomeAyaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    RandomVerse randomVerse = RandomVerse();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'من القرآن الكريم',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(randomVerse.verse,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp, fontFamily: TextFontType.quran2Font)),
              Text(
                '${quran.getSurahNameArabic(randomVerse.surahNumber)}, الاية ${randomVerse.verseNumber}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              RowAyaCopyShareShare(
                surahName: quran.getSurahNameArabic(randomVerse.surahNumber),
                verseNumber: randomVerse.verseNumber.toString(),
                verseText: randomVerse.verse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
