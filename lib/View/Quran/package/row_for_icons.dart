import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'audio_controler.dart';

class RowIconVerse extends StatelessWidget {
  const RowIconVerse({
    super.key,
    required this.verseTextForSurah,
    required this.surahName,
    required this.surahNumber,
    required this.surahVerseCount,
    required this.verseNumber,
  });

  final String verseTextForSurah;
  final String surahName;
  final int surahNumber;
  final int verseNumber;
  final int surahVerseCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(QuranicVersePlayer(
                surahNumber: surahNumber,
                verseNumber: verseNumber,
              ));
            },
            icon: const Icon(Icons.headphones_outlined),
          ),
          IconButton(
            icon: const Icon(
              Icons.copy_rounded,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: verseTextForSurah));
              Get.snackbar(surahName, 'تم نسخ الآية');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
            ),
            onPressed: () => _shareVerse(verseTextForSurah),
          ),
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
