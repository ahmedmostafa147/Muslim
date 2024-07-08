import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/get_tafser.dart';
import 'package:muslim/Core/constant/themes.dart';

class TafseerScreenPackage extends StatelessWidget {
  final QuranController quranController = Get.put(QuranController());

  TafseerScreenPackage({super.key});

  @override
  Widget build(BuildContext context) {
    final surahNumber = Get.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التفسير'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (quranController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final surah = quranController.getSurahByNumber(surahNumber);

          if (surah == null) {
            return const Center(
                child: Text('لم يتم العثور على بيانات لهذه السورة.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var ayah in surah.ayahs) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ayah.text,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: TextFontType.quranFont),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        ayah.tafseer,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: TextFontType.cairoFont,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                     
                    ],
                  ),
                ),
                 SizedBox(height: 15.h),
              ],
            ]),
          );
        }),
      ),
    );
  }
}
