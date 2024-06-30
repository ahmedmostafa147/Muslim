import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/loading_widget.dart';

import '../../screen/surah_screen_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'stack_of_number.dart';
import '../../../../Core/constant/style.dart';
import 'package:quran/quran.dart' as quran;

class ListSurahNamePackage extends StatefulWidget {
  const ListSurahNamePackage({super.key});

  @override
  State<ListSurahNamePackage> createState() => _ListSurahNamePackageState();
}

class _ListSurahNamePackageState extends State<ListSurahNamePackage> {
  int? lastReadIndex;
  @override
  void initState() {
    super.initState();
    loadLastReadItem();
  }

  // Save the index of the last item read
  Future<void> saveLastReadIndex(int lastIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadIndex', lastIndex);
  }

  // Retrieve the index of the last item read
  Future<int?> getLastReadIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('lastReadIndex');
  }

  // Call this function whenever the user reads a new item
  void onItemRead(int itemIndex) {
    saveLastReadIndex(itemIndex);
  }

  // Call this function when the app starts to load the last read item
  void loadLastReadItem() async {
    lastReadIndex = await getLastReadIndex();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: quran.totalSurahCount != 0
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: quran.totalSurahCount,
                        itemBuilder: (context, index) {
                          final surahNameArabic =
                              quran.getSurahNameArabic(index + 1);
                          final surahVerseCount =
                              quran.getVerseCount(index + 1);
                          final surahNameEnglish =
                              quran.getSurahName(index + 1);
                          final surahPlace =
                              quran.getPlaceOfRevelation(index + 1);
                          final surahIndex = (index + 1);

                          final bool isLastRead =
                              index == (lastReadIndex ?? -1);

                          return SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => SurahPage(
                                      surahIndex: surahIndex,
                                      surahVerseCount: surahVerseCount,
                                      surahName: surahNameArabic,
                                    ));
                                onItemRead(index);
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
                                            color: isLastRead
                                                ? Colors.blue
                                                : Theme.of(context)
                                                    .primaryColor,
                                            width: 1.5),
                                        color: isLastRead
                                            ? Colors.blue.withOpacity(0.1)
                                            : null,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    StackOfNumber(
                                                        surahIndex: surahIndex
                                                            .toString()),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Text(
                                                      "$surahNameArabic ",
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontFamily: TextFontType
                                                            .quranFont,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "  $surahNameEnglish",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: TextFontType
                                                        .notoNastaliqUrduFont,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Center(
                                              child: Text(
                                                " آياتها  ( $surahVerseCount ) • $surahPlace "
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: TextFontType
                                                      .notoNastaliqUrduFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const LoadingWidget()),
    );
  }
}
