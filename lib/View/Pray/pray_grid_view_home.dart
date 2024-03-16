import 'package:Muslim/Core/constant/Images.dart';

import 'pray_details.dart';
import '../../widgets/card_text_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrayHome extends StatelessWidget {
  PrayHome({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> gridData = [
    {
      'image': Assets.imagesSustainability,
      'text': ' الرزق والبركة',
      'filePath': 'assets/database/ادعية الرزق والبركة.json',
    },
    {
      'image': Assets.imagesTombstone,
      'text': 'ادعية المتوفى',
      'filePath': 'assets/database/ادعية المتوفى.json',
    },
    {
      'image': Assets.imagesGiveLove,
      'text': 'ادعية المغفرة ',
      'filePath': 'assets/database/ادعية المغفرة والتوبة.json',
    },
    {
      'image': Assets.imagesQuran1,
      'text': 'ادعية ختم القران',
      'filePath': 'assets/database/ادعية ختم القران.json',
    },
    {
      'image': Assets.imagesRating,
      'text': 'ادعية ذهاب الهم',
      'filePath': 'assets/database/ادعية ذهاب الهم.json',
    },
    {
      'image': Assets.imagesMortarboard,
      'text': 'ادعية طلب العلم',
      'filePath': 'assets/database/ادعية طلب العلم.json',
    },
    {
      'image': Assets.imagesMuhammad,
      'text': 'ادعية نبوية',
      'filePath': 'assets/database/ادعية نبوية.json',
    },
    {
      'image': Assets.imagesQuran,
      'text': 'ادعية قرآنية',
      'filePath': 'assets/database/ادعية قرآنية.json',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('الأدعية'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: gridData.length,
                  itemBuilder: (context, index) {
                    String categoryTitle = gridData[index]['text'];
                    String filePath = gridData[index]['filePath'];
                    return Container(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            PrayDetails(filePath: filePath),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color.fromARGB(44, 212, 163, 49)
                                    : const Color.fromARGB(44, 0, 150, 135),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Image.asset(gridData[index]['image'],
                                  width: 40.r, height: 40.r),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              categoryTitle,
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CardTextIconWidget(
                onTap: () {
                  Get.to(() => const ListPray());
                },
                text: "مسائل الدعاء",
                icon: Assets.imagesDuaHands,
              ),
              SizedBox(height: 200.h)
            ],
          ),
        ));
  }
}

class ListPray extends StatelessWidget {
  const ListPray({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listData = [
      {
        'image': Assets.imagesPraying,
        'text': 'الدعاء المستجاب',
        'filePath': 'assets/database/الدعاء المستجاب.json',
      },
      {
        'image': Assets.imagesPraying,
        'text': 'فضل الدعاء',
        'filePath': 'assets/database/فضل الدعاء.json',
      },
      {
        'image': Assets.imagesPraying,
        'text': 'الدعاء المنهى عنه',
        'filePath': 'assets/database/الدعاء المنهى عنه.json',
      },
      {
        'image': Assets.imagesPraying,
        'text': 'أوقات استجابة الدعاء',
        'filePath': 'assets/database/أوقات استجابة الدعاء.json',
      },
      {
        'image': Assets.imagesPraying,
        'text': 'آداب وشروط الدعاء',
        'filePath': 'assets/database/آداب وشروط الدعاء.json',
      },
    ];
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.teal, width: 1.0),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            String categoryTitle = listData[index]['text'];
            String filePath = listData[index]['filePath'];
            return Card(
                elevation: 5.0,
                child: InkWell(
                  onTap: () {
                    Get.to(
                      PrayDetails(filePath: filePath),
                    );
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(listData[index]['image'],
                            width: 50.r, height: 50.r),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        categoryTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ));
          },
          itemCount: listData.length,
        ),
      ),
    );
  }
}
