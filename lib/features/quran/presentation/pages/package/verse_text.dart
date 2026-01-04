import 'package:muslim/core/constants/themes.dart';import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerseText extends StatelessWidget {
  const VerseText({
    super.key,
    required this.verseText,
    required this.verseText1,
  });
  final String verseText;
  final String verseText1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  verseText1,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: TextFontType.notoNastaliqUrduFont,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
