import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/Core/constant/images.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/View/Quran/book/view.dart';
import 'package:muslim/View/Quran/package/surah_contain.dart';
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
              width: 3.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "القراءه من حيث ما توقفت",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (surahController.lastReadMode.value == 'list') ...[
                    Row(
                      children: [
                        const Text("توقفت عند"),
                        Text(
                          quran.getSurahNameArabic(
                              surahController.surahNumber.value),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("توقفت عند الأية ",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          surahController.verseNumber.value.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
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
                        const Text("توقفت عند  ",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          (surahController.surahName.value),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.quran2Font),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("توقفت عند الصفحة ",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          surahController.pageNumber.value.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                  ElevatedButton(
                    child: const Text("عرض"),
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
