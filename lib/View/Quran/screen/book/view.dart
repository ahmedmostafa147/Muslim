import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muslim/Controller/surah_view.dart';
import 'package:muslim/widgets/loading_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';

class QuranImagesScreen extends StatelessWidget {
  final QuranViewController quranController = Get.put(QuranViewController());
  final int initialSurahIndex;

  QuranImagesScreen({super.key, required this.initialSurahIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreloadPageView.builder(
        controller: PreloadPageController(initialPage: initialSurahIndex - 1),
        itemCount: quranController.surahNames.length,
        preloadPagesCount: 2, // Load 2 pages ahead
        itemBuilder: (context, index) {
          final surahName = quranController.surahNames[index];
          final imageUrl = quranController.getSurahImageUrl(surahName);

          // Preload next 2 images
          if (index + 2 < quranController.surahNames.length) {
            quranController.prefetchImages(index + 1, 2);
          }
          return Center(
            child: CachedNetworkImage(
              color: Colors.teal,
              imageUrl: imageUrl,
              placeholder: (context, url) => const LoadingWidget(),
              errorWidget: (context, url, error) => const Text("فشل التحميل"),
            ),
          );
        },
      ),
    );
  }
}
