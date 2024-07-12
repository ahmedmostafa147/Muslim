import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/Models/api_reciters.dart';
import 'package:muslim/View/Quran/package/stack_of_number.dart';
import 'package:muslim/View/Reader/play_surah.dart';
import 'package:quran/quran.dart' as quran;

class SurahListScreen extends StatelessWidget {
  final Moshaf moshaf;
  final Reciter reciter;

  const SurahListScreen({super.key, required this.moshaf, required this.reciter});

  @override
  Widget build(BuildContext context) {
    final surahList = moshaf.surahList?.split(',') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("اختار سورة"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: surahList.length,
              itemBuilder: (context, index) {
                int surahId = int.parse(surahList[index]);
                String surahNameArabic = quran.getSurahNameArabic(surahId);
                String surahNameEnglish = quran.getSurahNameEnglish(surahId);

                return AudioTittle(
                  surahName: surahNameArabic,
                  surahNameen: surahNameEnglish,
                  totalAya: quran.getVerseCount(surahId),
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
            ),
          ),
        ],
      ),
    );
  }
}

class AudioTittle extends StatelessWidget {
  final String? surahName;
  final String? surahNameen;
  final int? totalAya;
  final int? number;
  final VoidCallback? onTap;

  const AudioTittle({
    super.key,
    required this.surahName,
    required this.surahNameen,
    required this.totalAya,
    required this.number,
    required this.onTap,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            StackOfNumber(
                              surahIndex: number.toString(),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "$surahName",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: TextFontType.quranFont,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$surahNameen",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: TextFontType.notoNastaliqUrduFont,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
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
