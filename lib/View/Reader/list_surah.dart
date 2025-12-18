import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/surah_search.dart';
import '../../Core/constant/themes.dart';
import '../../Models/api_reciters.dart';
import '../Quran/package/stack_of_number.dart';
import 'play_surah.dart';
import 'package:quran/quran.dart' as quran;

class SurahListScreen extends StatelessWidget {
  final Moshaf moshaf;
  final Reciter reciter;
  final SurahController surahController = Get.put(SurahController());

  SurahListScreen({super.key, required this.moshaf, required this.reciter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختار سورة"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: surahController.searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'بحث عن سورة...',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                surahController.filterSearchResults(value);
              },
            ),
          ),
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: surahController.filteredSurahNames.length,
            itemBuilder: (context, index) {
              String surahNameArabic =
                  surahController.filteredSurahNames[index];
              final surahId =
                  surahController.allSurahNames.indexOf(surahNameArabic) + 1;

              final surahPlace = quran.getPlaceOfRevelation(surahId);

              String surahNameEnglish = quran.getSurahName(surahId);

              return AudioTittle(
                surahName: surahNameArabic,
                surahNameEn: surahNameEnglish,
                totalAya: quran.getVerseCount(surahId),
                surahPlace: surahPlace,
                number: surahId,
                onTap: () {
                  String surahUrl = '${moshaf.server}$surahId.mp3';
                  Get.to(
                    () => PlaySurah(
                      surahId: surahId,
                      surahUrl: surahUrl,
                      surahName: surahNameArabic,
                      readerName: reciter.name ?? '',
                      moshafName: moshaf.name ?? "",
                      moshaf: moshaf,
                      reciter: reciter,
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}

class AudioTittle extends StatelessWidget {
  final String? surahName;
  final String? surahNameEn;
  final int? totalAya;
  final String? surahPlace;

  final int? number;
  final VoidCallback? onTap;

  const AudioTittle({
    super.key,
    required this.surahName,
    required this.surahNameEn,
    required this.totalAya,
    required this.number,
    required this.onTap,
    required this.surahPlace,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: onTap,
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
                    color: Theme.of(context).primaryColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            StackOfNumber(surahIndex: number.toString()),
                            SizedBox(width: 10.w),
                            Text(
                              surahName ?? '',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: TextFontType.quranFont,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          surahNameEn ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).primaryColor,
                            fontFamily: TextFontType.notoNastaliqUrduFont,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        "آياتها ( $totalAya ) • $surahPlace",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: TextFontType.notoNastaliqUrduFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
