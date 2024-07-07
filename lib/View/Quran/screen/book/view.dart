import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muslim/Controller/get_tafser.dart';
import 'package:muslim/View/Quran/screen/book/tafser.dart';

import 'package:muslim/Controller/surah_view.dart';
import 'package:muslim/widgets/loading_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';

class QuranImagesScreen extends StatelessWidget {
  final QuranViewController quranViewController =
      Get.put(QuranViewController());
  final QuranController quranController = Get.put(QuranController());

  QuranImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final numOfPage = Get.arguments as int;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (quranController.isLoading.value) {
            return const LoadingWidget();
          }

          return PreloadPageView.builder(
            controller: PreloadPageController(initialPage: numOfPage - 1),
            itemCount: quranViewController.surahNames.length,
            preloadPagesCount: 2,
            itemBuilder: (context, index) {
              final surahName = quranViewController.surahNames[index];
              final imageUrl = quranViewController.getSurahImageUrl(surahName);
              if (index + 2 < quranViewController.surahNames.length) {
                quranViewController.prefetchImages(index + 1, 2);
              }

              return GestureDetector(
                onTap: () {
                  Get.to(() => QuranPageScreen(), arguments: index + 1);
                },
                child: CachedNetworkImage(
                  color: Colors.teal,
                  imageUrl: imageUrl,
                  placeholder: (context, url) => const LoadingWidget(),
                  errorWidget: (context, url, error) =>
                      const Text("فشل التحميل"),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
