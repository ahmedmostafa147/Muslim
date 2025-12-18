import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Reader/reciters_list_screen.dart';
import '../../../Core/constant/images.dart';
import '../../Quran/screen/surah_name_p.dart';
import '../../Radio/radio_home.dart';
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
                  onTap: () {
                        Get.to(() => RecitersListScreen());
                  },
                  image: Assets.imagesAudioBook,
                  text: "القراء"),
              IconAndTextGridView(
                onTap: () {
                  Get.to(const RadioHomeScreen());
                },
                image: Assets.imagesRadiogrid,
                text: 'الراديو',
              )
            ],
          ),
        ],
      ),
    );
  }
}
