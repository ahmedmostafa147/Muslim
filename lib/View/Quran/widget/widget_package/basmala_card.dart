import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/constant/text_style.dart';
import 'package:quran/quran.dart';

class BasmalaCardSurah extends StatelessWidget {
  const BasmalaCardSurah({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          " $basmala",
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: TextFontStyle.quranFont,
          ),
        ),
      ),
    );
  }
}
