import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/constant/style.dart';

class StackOfNumber extends StatelessWidget {
  const StackOfNumber({super.key, required this.surahIndex});
  final String surahIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SizedBox(
            height: 25.h,
            width: 30.w,
            child: Center(
              child: Text(
                surahIndex,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: TextFontType.notoNastaliqUrduFont,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
