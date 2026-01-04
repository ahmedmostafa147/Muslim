import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/features/quran/presentation/pages/screen/surah_name_p.dart';
import 'package:muslim/features/radio/presentation/pages/radio_home.dart';
import '../../../../core/constants/images.dart';

import 'home_icon_text_for_grid.dart';

class GridQuranScreens extends StatelessWidget {
  const GridQuranScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "اختصارات للقران الكريم ",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            children: [
              IconAndTextGridView(
                onTap: () {
                  Get.to(
                    const ListSurahNamePackage(),
                  );
                },
                image: Assets.imagesQuranforselecte,
                text: 'القرآن الكريم',
              ),
              IconAndTextGridView(
                  onTap: () {}, image: Assets.imagesAzkar, text: "القراء"),
              IconAndTextGridView(
                onTap: () {
                  Get.to(const RadioHomeScreen());
                },
                image: Assets.imagesRadio,
                text: 'الراديو',
              )
            ],
          ),
        ],
      ),
    );
  }
}
