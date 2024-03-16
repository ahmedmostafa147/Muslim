import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconAndTextGridView extends StatelessWidget {
  IconAndTextGridView(
      {super.key,
      required this.text,
      required this.image,
      required this.onTap});
  final String text;
  final String image;
  VoidCallback onTap;

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
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(44, 212, 163, 49)
                  : const Color.fromARGB(44, 0, 150, 135),
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
