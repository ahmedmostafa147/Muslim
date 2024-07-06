import 'package:flutter/material.dart';
import '../widget/widget_package/surah_contain.dart';

class SurahPage extends StatelessWidget {
  final int surahIndex;
  final int surahVerseCount;
  final String surahName;

  const SurahPage({
    super.key,
    required this.surahIndex,
    required this.surahVerseCount,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SurahContainList(
      surahIndex: surahIndex,
      surahVerseCount: surahVerseCount,
      surahName: surahName,
    ));
  }
}
