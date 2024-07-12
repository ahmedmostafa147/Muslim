import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constant/images.dart';
import 'package:muslim/Core/constant/themes.dart';

class RadioListUi extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RadioListUi({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).primaryColor,
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
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: TextFontType.cairoFont,
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
