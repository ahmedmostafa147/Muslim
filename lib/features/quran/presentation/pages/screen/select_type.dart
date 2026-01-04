import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/core/constants/images.dart';
import 'package:muslim/features/widgets/container_custom.dart';
import '../book/view.dart';
import '../package/surah_contain.dart';

class SelectTypeReading extends StatelessWidget {
  final int surahIndex;
  final int surahVerseCount;
  final String surahName;
  final int pageNumber;

  const SelectTypeReading({
    super.key,
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
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
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SurahContainList(),
                      settings: RouteSettings(arguments: {
                        'surahIndex': surahIndex,
                        'surahVerseCount': surahVerseCount,
                        'surahName': surahName,
                        'versenumberfromlastread': 0,
                      }),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
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
                    Text("قائمة", style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
              // Container for Book Icon
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuranImagesScreen(),
                      settings:
                          RouteSettings(arguments: {'pageNumber': pageNumber}),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
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
