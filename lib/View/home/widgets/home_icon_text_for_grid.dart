// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:muslim/Core/constant/themes.dart';
class IconAndTextGridView extends StatelessWidget {
  const IconAndTextGridView({
    super.key,
    required this.text,
    required this.image,
    this.onTap,
  });

  final String text;
  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: ColorsStyleApp.hoverLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.asset(
              image,
              width: 40.w,
              height: 40.h,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
