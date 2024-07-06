import '../../../../widgets/loading_widget.dart';

import 'audio_screen.dart';
import 'package:get/get.dart';

import '../../../../Models/surah_sound_load_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget_package/stack_of_number.dart';
import '../../../../Models/reader_load_data.dart';
import 'package:muslim/Core/constant/themes.dart';
class AudioSurahScreen extends StatelessWidget {
  AudioSurahScreen({Key? key, required this.reader}) : super(key: key);
  final Reader reader;

  SurahSoundLoadData surahSoundLoadData = SurahSoundLoadData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "اختار سورة",
        ),
      ),
      body: FutureBuilder(
        future: surahSoundLoadData.getSurah(),
        builder: (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
          if (snapshot.hasData) {
            List<Surah>? surah = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: surah!.length,
                      itemBuilder: (context, index) => AudioTittle(
                          surahName: snapshot.data![index].name,
                          surahNameen: snapshot.data![index].englishName,
                          totalAya: snapshot.data![index].numberOfAyahs,
                          number: snapshot.data![index].number,
                          onTap: () {
                            Get.bottomSheet(AudioScreen(
                              reader: reader,
                              index: index + 1,
                              list: surah,
                            ));
                          })),
                ),
              ],
            );
          }
          return LoadingWidget();
        },
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
