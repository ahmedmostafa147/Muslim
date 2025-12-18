import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;
import 'package:visibility_detector/visibility_detector.dart';
import '../../../features/quran/presentation/cubit/last_read_cubit.dart';
import '../../../features/quran_audio/presentation/cubit/quran_audio_cubit.dart';
import '../../../features/quran_audio/presentation/cubit/quran_audio_state.dart';
import 'basmallah.dart';
import 'row_for_icons.dart';
import 'stack_of_number.dart';
import 'verse_text.dart';

class VerseItem extends StatelessWidget {
  final int surahIndex;
  final int verseIndex;
  final String surahName;
  final int surahVerseCount;

  const VerseItem({
    super.key,
    required this.surahIndex,
    required this.verseIndex,
    required this.surahName,
    required this.surahVerseCount,
  });

  @override
  Widget build(BuildContext context) {
    final verseNumber = verseIndex + 1;
    final verseText =
        quran.getVerse(surahIndex, verseNumber, verseEndSymbol: true);
    final verseText1 = quran.getVerseTranslation(surahIndex, verseNumber);
    final bool isBismillahRequired =
        surahIndex != 1 && surahIndex != 9 && verseNumber == 1;

    return VisibilityDetector(
      key: Key('$surahIndex:$verseNumber'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.5) {
          final lastReadCubit = context.read<LastReadCubit>();
          lastReadCubit.setSurah(surahName);
          lastReadCubit.setSurahIndex(surahIndex);
          lastReadCubit.setVerse(verseNumber);
        }
      },
      child: Column(
        children: [
          if (isBismillahRequired) const Basmallah(),
          Padding(
            padding: EdgeInsets.fromLTRB(7.w, 10.w, 7.w, 10.w),
            child: BlocBuilder<QuranAudioCubit, QuranAudioState>(
              buildWhen: (prev, curr) => prev.verseNumber != curr.verseNumber,
              builder: (context, state) {
                final isCurrentVerse = state.verseNumber == verseNumber &&
                    state.surahNumber == surahIndex;
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                    color: isCurrentVerse
                        ? Colors.blue.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StackOfNumber(surahIndex: verseNumber.toString()),
                          RowIconVerse(
                            verseNumber: verseNumber,
                            surahNumber: surahIndex,
                            verseTextForSurah: verseText,
                            surahName: surahName,
                            surahVerseCount: surahVerseCount,
                            onHeadphonePressed: () {
                              final audioCubit =
                                  context.read<QuranAudioCubit>();
                              audioCubit.setVerse(surahIndex, verseNumber,
                                  verseText, surahName);
                              audioCubit.togglePlayerVisibility();
                              audioCubit.play();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 15.w, 7.w, 15.w),
                        child: VerseText(
                            verseText1: verseText1, verseText: verseText),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
