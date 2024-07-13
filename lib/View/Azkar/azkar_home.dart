import '../../Core/constant/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'azkar_details.dart';

class AzkarHome extends StatelessWidget {
  final List<Map<String, dynamic>> supplicationCategories = [
    {
      'image': Assets.imagesDawn,
      'text': 'أذكار الصباح',
      'filePath': 'assets/database/أذكار الصباح .json',
    },
    {
      'image': Assets.imagesNightwave,
      'text': 'أذكار المساء',
      'filePath': 'assets/database/أذكار المساء .json',
    },
    {
      'image': Assets.imagesAlarm,
      'text': "أذكار الاستيقاظ",
      'filePath': 'assets/database/أذكار الاستيقاظ .json',
    },
    {
      'image': Assets.imagesSleeping,
      'text': 'أذكار النوم ',
      'filePath': 'assets/database/أذكار النوم .json',
    },
    {
      'image': Assets.imagesGridmosque,
      'text': 'أذكار المسجد',
      'filePath': 'assets/database/أذكار المسجد .json',
    },
    {
      'image': Assets.imagesSalahmuslim,
      'text': 'أذكار الصلاه',
      'filePath': 'assets/database/أذكار الصلاه .json',
    },
    {
      'image': Assets.imagesPrayingGrid,
      'text': 'أذكار بعد الصلاة ',
      'filePath': 'assets/database/أذكار بعد الصلاة .json',
    },
    {
      'image': Assets.imagesIftar,
      'text': 'أذكار الطعام',
      'filePath': 'assets/database/أذكار الطعام .json',
    },
    {
      'image': Assets.imagesHood,
      'text': 'أذكار اللباس الجديد',
      'filePath': 'assets/database/أذكار اللباس الجديد .json',
    },
  ];

  AzkarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('الأذكار'),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: supplicationCategories.length,
          itemBuilder: (context, index) {
            String categoryTitle = supplicationCategories[index]['text'];
            String filePath = supplicationCategories[index]['filePath'];
            return InkWell(
              onTap: () {
                Get.to(
                  AzkarDetails(filePath: filePath),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Image.asset(supplicationCategories[index]['image'],
                        width: 40.w, height: 40.h),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(categoryTitle),
                ],
              ),
            );
          },
        ));
  }
}
