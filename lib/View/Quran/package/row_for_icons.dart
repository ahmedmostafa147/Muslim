import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/bookmark_favourit_cont.dart';
import 'package:share_plus/share_plus.dart';

class RowIconVerse extends StatelessWidget {
  const RowIconVerse({
    super.key,
    required this.verseTextForSurah,
    required this.surahName,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahVerseCount,
    required this.onHeadphonePressed,
  });

  final String verseTextForSurah;
  final String surahName;
  final int surahNumber;
  final int verseNumber;
  final int surahVerseCount;
  final VoidCallback onHeadphonePressed;

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.put(BookmarkController());
    final favoriteController = Get.put(FavoriteController());
    final verseKey = '$surahNumber:$verseNumber';

    return Card(
      elevation: 5,
      child: Row(
        children: [
          IconButton(
            onPressed: onHeadphonePressed, 
            icon: const Icon(Icons.headphones_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: verseTextForSurah));
              Get.snackbar(surahName, 'تم نسخ الآية');
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareVerse(verseTextForSurah),
          ),
          Obx(() {
            final isBookmarked = bookmarkController.isBookmarked(verseKey);
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              ),
              onPressed: () {
                bookmarkController.toggleBookmark(verseKey);
                Get.snackbar(
                  surahName,
                  isBookmarked ? 'تم إزالة العلامة' : 'تم إضافة العلامة',
                );
              },
            );
          }),
          Obx(() {
            final isFavorite = favoriteController.isFavorite(verseKey);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                favoriteController.toggleFavorite(verseKey);
                Get.snackbar(
                  surahName,
                  isFavorite ? 'تم إزالة من المفضلة' : 'تم إضافة للمفضلة',
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _shareVerse(String verseText) {
    final String text = '$surahName - $verseText';
    const String subject = 'Quran';
    Share.share(text, subject: subject);
  }
}
