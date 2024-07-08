import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/View/Quran/screen/select_type.dart';
import 'package:quran/quran.dart' as quran;
import '../../../widgets/loading_widget.dart';
import '../package/stack_of_number.dart';
import 'package:muslim/Core/constant/themes.dart';

class ListSurahNamePackage extends StatelessWidget {
  const ListSurahNamePackage({super.key});

  @override
  Widget build(BuildContext context) {
    final SurahController surahController = Get.put(SurahController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن'),
      ),
      body: Obx(() {
        if (quran.totalSurahCount == 0) {
          return const LoadingWidget();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: false,
                controller: surahController.searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "ابحث عن اسم السورة ",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  surahController.filterSearchResults(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: surahController.filteredSurahNames.length,
                itemBuilder: (context, index) {
                  final surahNameArabic =
                      surahController.filteredSurahNames[index];
                  final surahIndex =
                      surahController.allSurahNames.indexOf(surahNameArabic) +
                          1;
                  final surahVerseCount = quran.getVerseCount(surahIndex);
                  final surahNameEnglish = quran.getSurahName(surahIndex);
                  final surahPlace = quran.getPlaceOfRevelation(surahIndex);
                  final numOfPage = quran.getPageNumber(surahIndex, 1);

                  return GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        settings: RouteSettings(
                          arguments: {
                            'surahIndex': surahIndex,
                            'surahVerseCount': surahVerseCount,
                            'surahName': surahNameArabic,
                            'pageNumber': numOfPage,
                          },
                        ),
                        const SelectTypeReading(),
                        isScrollControlled: true,
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 600),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 600),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        enableDrag: false,
                      );
                    },
                    child: ListView(
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
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        StackOfNumber(
                                            surahIndex: surahIndex.toString()),
                                        SizedBox(width: 10.w),
                                        Text(
                                          surahNameArabic,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: TextFontType.quranFont,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      surahNameEnglish,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily:
                                            TextFontType.notoNastaliqUrduFont,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Center(
                                  child: Text(
                                    "آياتها ( $surahVerseCount ) • $surahPlace",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily:
                                          TextFontType.notoNastaliqUrduFont,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
