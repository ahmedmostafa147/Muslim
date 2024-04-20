import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Core/constant/doe_verser.dart';
import '../Core/constant/style.dart';
import '../View/Quran/widget/widget_package/row_aya_copy_love_share.dart';

class DoaCardWidget extends StatefulWidget {
  const DoaCardWidget({super.key});

  @override
  State<DoaCardWidget> createState() => _DoaCardWidgetState();
}

class _DoaCardWidgetState extends State<DoaCardWidget> {
  final int index = Random().nextInt(StaticVars().smallDo3a2.length - 1);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorsStyleApp.darkPrimary
                : ColorsStyleApp.lightPrimary,
            width: 1.0),
      ),
      child: Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "دعاء اليوم",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? ColorsStyleApp.darkPrimary
                            : ColorsStyleApp.lightPrimary,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      StaticVars().smallDo3a2[index],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: TextFontType.quranFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          RowDoaCopyShareShare(
            doaText: StaticVars().smallDo3a2[index],
          ),
        ],
      ),
    );
  }
}
