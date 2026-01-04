import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;
import '../../../../core/di/injection.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/themes.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../quran/presentation/cubit/last_read_cubit.dart';
import '../../../quran/presentation/cubit/last_read_state.dart';
import '../../../quran/presentation/pages/book/view.dart';
import '../../../quran/presentation/pages/package/surah_contain.dart';

class LastRead extends StatelessWidget {
  const LastRead({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LastReadCubit>(),
      child: BlocBuilder<LastReadCubit, LastReadState>(
        builder: (context, state) {
          if (!state.isVisible) {
            return const SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "القراءة من حيث توقفت",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (state.lastReadMode == 'list') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "توقفت عند",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            quran.getSurahNameArabic(state.surahNumber),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.arefRuqaaFont,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "توقفت عند الأية ",
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            state.verseNumber.toString(),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ] else if (state.lastReadMode == 'mushaf') ...[
                      Row(
                        children: [
                          Text(
                            "توقفت عند  ",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            state.surahName,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.quranFont,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "توقفت عند الصفحة ",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            state.pageNumber.toString(),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                    SizedBox(height: 10.0.h),
                    CustomMaterialButton(
                      buttonText: 'متابعة القراءة',
                      color: Theme.of(context).primaryColor,
                      height: 35.h,
                      onPressed: () {
                        if (state.lastReadMode == 'list' &&
                            state.surahNumber > 0 &&
                            state.verseNumber > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SurahContainList(),
                              settings: RouteSettings(arguments: {
                                'surahIndex': state.surahNumber,
                                'surahVerseCount':
                                    quran.getVerseCount(state.surahNumber),
                                'surahName':
                                    quran.getSurahName(state.surahNumber),
                                'versenumberfromlastread':
                                    state.verseNumber - 1,
                              }),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuranImagesScreen(),
                              settings: RouteSettings(arguments: {
                                'pageNumber': state.pageNumber,
                              }),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 10.0),
                Image.asset(Assets.imagesRadio, width: 80.w, height: 80.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
