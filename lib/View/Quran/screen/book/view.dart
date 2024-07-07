import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: Obx(() {
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

            return Scaffold(
              appBar: AppBar(
                title: const Text('القرآن'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => TafseerScreen(), arguments: index + 1);
                    },
                    icon: const Icon(Icons.book),
                  ),
                ],
              ),
              body: GestureDetector(
                onTap: () {},
                child: SafeArea(
                  child: CachedNetworkImage(
                    color: Colors.teal,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const LoadingWidget(),
                    errorWidget: (context, url, error) =>
                        const Text("فشل التحميل"),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
