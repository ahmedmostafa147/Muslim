import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Muslim/Core/constant/Images.dart';
import 'package:Muslim/Core/constant/text_style.dart';

class RadioListUi extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RadioListUi({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.teal,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ImageIcon(
                  const AssetImage(Assets.imagesRadioLogo),
                  size: 30.r,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: TextFontStyle.cairoFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
