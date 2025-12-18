import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerTimeItem extends StatelessWidget {
  final String name;
  final String time;
  final String imagePath;
  final bool isHighlighted;

  const PrayerTimeItem({
    super.key,
    required this.name,
    required this.time,
    required this.imagePath,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isHighlighted
            ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlighted
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
          width: isHighlighted ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 40.w,
            height: 40.h,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
