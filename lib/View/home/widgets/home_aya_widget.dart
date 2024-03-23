import 'dart:math';
import 'package:Muslim/Core/constant/text_style.dart';
import 'package:Muslim/View/Quran/widget/widget_package/row_aya_copy_love_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;

class HomeAyaWidget extends StatelessWidget {
  const HomeAyaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final surahNumber = Random().nextInt(114) + 1;
    final surahName = quran.getSurahNameArabic(surahNumber);
    final verseNumber = Random().nextInt(quran.getVerseCount(surahNumber)) + 1;
    final verseText = quran.getVerse(surahNumber, verseNumber);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Card(
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0XFFD4A331)
                        : Colors.teal,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(verseText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.sp, fontFamily: TextFontStyle.quran2Font)),
                Text(
                  '$surahName, الاية $verseNumber',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                 RowAyaCopyShareShare(

                  surahName: surahName,
                  verseNumber: verseNumber.toString(),
                  verseText: verseText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
