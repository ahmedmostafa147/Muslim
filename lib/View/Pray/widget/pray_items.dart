import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/Core/constant/themes.dart';

class PrayItems extends StatelessWidget {
  final String pray;

  const PrayItems({
    super.key,
    required this.pray,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
            
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  pray,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: TextFontType.arefRuqaaFont,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                  ],
                ),
              ],
            ),
          ),
        ]);
  }
}
