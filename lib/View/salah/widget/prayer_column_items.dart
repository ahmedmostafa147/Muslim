import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildPrayerTimeItemColumn extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;
  final Color containerColor;

  const BuildPrayerTimeItemColumn({
    super.key,
    required this.name,
    required this.imagePath,
    required this.time,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Image.asset(imagePath),
                ),
                SizedBox(width: 20.w),
                Text(
                  name,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
