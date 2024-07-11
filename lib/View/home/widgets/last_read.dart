import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/Core/constant/images.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/View/Quran/book/view.dart';
import 'package:muslim/View/Quran/package/surah_contain.dart';
import 'package:muslim/widgets/matreial_button.dart';
import 'package:quran/quran.dart' as quran;

class LastRead extends StatelessWidget {
  const LastRead({super.key});

  @override
  Widget build(BuildContext context) {
    final surahController = Get.put(SurahControllerSave());

    return Obx(() {
      if (surahController.lastReadSurahVisible.value) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "القراءة من حيث توقفت",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (surahController.lastReadMode.value == 'list') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("توقفت عند",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        const SizedBox(width: 5.0),
                        Text(
                          quran.getSurahNameArabic(
                              surahController.surahNumber.value),
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.quran2Font),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("توقفت عند الأية ",
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        Text(
                          surahController.verseNumber.value.toString(),
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ] else if (surahController.lastReadMode.value ==
                      'mushaf') ...[
                    Row(
                      children: [
                        Text("توقفت عند  ",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        Text(
                          (surahController.surahName.value),
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.quranFont),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("توقفت عند الصفحة ",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        Text(
                          surahController.pageNumber.value.toString(),
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                  SizedBox(height: 10.0.h),
                  CustomMaterialButton(
                    buttonText: 'متابعة القراءة',
                    color: Theme.of(context).primaryColor,
                    height: 35.h,
                    onPressed: () {
                      final lastSurahIndex = surahController.surahNumber.value;
                      final lastVerse = surahController.verseNumber.value;
                      final lastPage = surahController.pageNumber.value;
                      final lastMode = surahController.lastReadMode.value;

                      if (lastMode == 'list' &&
                          lastSurahIndex > 0 &&
                          lastVerse > 0) {
                        Get.to(
                          () => const SurahContainList(),
                          arguments: {
                            'surahIndex': lastSurahIndex,
                            'surahVerseCount':
                                quran.getVerseCount(lastSurahIndex),
                            'surahName': quran.getSurahName(lastSurahIndex),
                            'versenumberfromlastread': lastVerse - 1,
                          },
                        );
                      } else {
                        Get.to(() => QuranImagesScreen(),
                            arguments: {'pageNumber': lastPage});
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                  width: 10.0), // Add spacing between column and image
              Image.asset(Assets.imagesRadioLogo, width: 80.w, height: 80.h),
            ],
          ),
        );
      } else {
        return const SizedBox
            .shrink(); // Return an empty widget if condition is not met
      }
    });
  }
}
