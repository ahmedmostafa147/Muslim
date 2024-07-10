import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/get_tafser.dart';
import 'package:muslim/Controller/surah_search.dart';
import 'package:muslim/Controller/surah_view.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/View/Quran/book/tafser.dart';
import 'package:muslim/widgets/loading_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';

class QuranImagesScreen extends StatelessWidget {
  final QuranViewController quranViewController =
      Get.put(QuranViewController());
  final QuranController quranController = Get.put(QuranController());

  QuranImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int pageNumber = Get.arguments['pageNumber'];
    final PreloadPageController pageController =
        PreloadPageController(initialPage: pageNumber - 1);
    final surahController = Get.put(SurahControllerSave());

    return Scaffold(
      body: Obx(() {
        if (quranController.isLoading.value) {
          return const LoadingWidget();
        }

        return PreloadPageView.builder(
          controller: pageController,
          itemCount: quranViewController.surahNames.length,
          preloadPagesCount: 0, // تحميل مسبق لصفحتين قبل الصفحة الحالية وبعدها
          itemBuilder: (context, index) {
            final currentPage = index + 1;
            final surahName = quranViewController.surahNames[index];
            final imageUrl = quranViewController.getSurahImageUrl(surahName);

            if (index > 0) {
              final prevPageImageUrl = quranViewController
                  .getSurahImageUrl(quranViewController.surahNames[index - 1]);
              precacheImage(NetworkImage(prevPageImageUrl), context);
            }
            if (index + 1 < quranViewController.surahNames.length) {
              final nextPageImageUrl = quranViewController
                  .getSurahImageUrl(quranViewController.surahNames[index + 1]);
              precacheImage(NetworkImage(nextPageImageUrl), context);
            }

            final ayahs = quranController.getAyahsByPage(currentPage);
            final surah = quranController.getSurahByPage(currentPage);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              surahController.setSurah(surah!.name);
              surahController.setPage(currentPage);
              surahController.lastReadMode.value = 'mushaf';
            });

            return Scaffold(
              appBar: AppBar(
                title: const Text('القرآن'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => TafseerScreen(), arguments: currentPage);
                    },
                    icon: const Icon(Icons.book),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'الجزء: ${ayahs!.first.juz}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: TextFontType.cairoFont,
                          ),
                        ),
                        Text(
                          surah!.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: TextFontType.quranFont,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3.0,
                        ),
                      ),
                      child: CachedNetworkImage(
                        color: Colors.teal,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const LoadingWidget(),
                        errorWidget: (context, url, error) =>
                            const Text("فشل التحميل"),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      '$currentPage',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
