import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/get_tafser.dart';
import 'package:muslim/Core/constant/themes.dart';

class QuranPageScreen extends StatelessWidget {
  final QuranController quranController = Get.put(QuranController());

  QuranPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageNumber = Get.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التفسير'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (quranController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final ayahs = quranController.getAyahsByPage(pageNumber);
          final surah = quranController.getSurahByPage(pageNumber);

          if (ayahs == null || surah == null) {
            return const Center(
                child: Text('لم يتم العثور على بيانات لهذه الصفحة.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var ayah in ayahs) ...[
                  Text(
                    ' ${surah.name} الآية: ${ayah.numberInSurah}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.teal,
                      fontFamily: TextFontType.quranFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    ayah.text,
                    style: TextStyle(
                        fontSize: 20.sp, fontFamily: TextFontType.quranFont),
                  ),
                  SizedBox(height: 15.h),
                  const Divider(),
                  SizedBox(height: 15.h),
                  Text(
                    ayah.tafseer,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: TextFontType.cairoFont,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حزب: ${ayah.hizbQuarter}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'صفحة: ${ayah.page}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
