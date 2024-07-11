import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMaterialButton extends StatelessWidget {
  final String buttonText;
  final Function? onPressed;
  final Color? color;
  final IconData? fontAwesomeIcons;
  final height;

  const CustomMaterialButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      this.color,
      this.fontAwesomeIcons,
      this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height ?? 50.h,
      color: color ?? Colors.teal,
      textColor: Colors.white,
      onPressed: onPressed as void Function()?,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (fontAwesomeIcons != null)
            Icon(fontAwesomeIcons, size: 20.w, color: Colors.white),
          SizedBox(width: 10.w),
          Text(buttonText,
              style: TextStyle(
                fontSize: 16.sp,
              )),
        ],
      ),
    );
  }
}
