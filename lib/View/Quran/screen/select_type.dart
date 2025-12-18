import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Core/constant/images.dart';
import '../book/view.dart';
import '../package/surah_contain.dart';
import '../../../widgets/container_custom.dart';

class SelectTypeReading extends StatelessWidget {
  const SelectTypeReading({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final surahIndex = arguments['surahIndex'] as int;
    final surahVerseCount = arguments['surahVerseCount'] as int;
    final surahName = arguments['surahName'] as String;
    final pageNumber = arguments['pageNumber'];

    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("اختار وضعية القراءة المفضلة",
              style: TextStyle(fontSize: 20.sp)),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container for List Icon
              InkWell(
                onTap: () {
                  Get.to(() => const SurahContainList(), arguments: {
                    'surahIndex': surahIndex,
                    'surahVerseCount': surahVerseCount,
                    'surahName': surahName,
                    'versenumberfromlastread': 0
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Center(
                        child: Image(
                          image: const AssetImage(Assets.imagesSmartphone),
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("قائمة", style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
              // Container for Book Icon
              InkWell(
                onTap: () {
                  Get.to(() => QuranImagesScreen(),
                      arguments: {'pageNumber': pageNumber});
                },
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Center(
                        child: Image(
                          image: const AssetImage(Assets.imagesQuranforselecte),
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("المصحف", style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
