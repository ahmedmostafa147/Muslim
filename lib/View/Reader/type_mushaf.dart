import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/constant/images.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/Models/api_reciters.dart';
import 'package:muslim/View/Reader/list_surah.dart';
import 'package:muslim/widgets/container_custom.dart';

class MoshafListScreen extends StatelessWidget {
  final Reciter reciter;

  const MoshafListScreen({Key? key, required this.reciter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciter.name ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
            mainAxisExtent: 250,
          ),
          itemCount: reciter.moshaf?.length ?? 0,
          itemBuilder: (context, index) {
            final moshaf = reciter.moshaf![index];
            return GestureDetector(
              onTap: () {
                Get.to(() => SurahListScreen(moshaf: moshaf, reciter: reciter));
              },
              child: Column(
                children: [
                  CustomContainer(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.imagesAudioBook,
                            height: 80.h,
                            width: 80.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      moshaf.name ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: TextFontType.quranFont,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
