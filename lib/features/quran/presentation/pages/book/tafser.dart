import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/core/constants/themes.dart';
import 'package:muslim/core/di/injection.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/tafseer_cubit.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/tafseer_state.dart';

class TafseerScreen extends StatelessWidget {
  final int pageNumber;

  const TafseerScreen({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TafseerCubit>(),
      child: _TafseerPageView(pageNumber: pageNumber),
    );
  }
}

class _TafseerPageView extends StatelessWidget {
  final int pageNumber;

  const _TafseerPageView({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التفسير')),
      body: SafeArea(
        child: BlocBuilder<TafseerCubit, TafseerState>(
          builder: (context, state) {
            if (state.status == TafseerStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final ayahs = state.getAyahsByPage(pageNumber);
            final surah = state.getSurahByPage(pageNumber);

            if (ayahs == null || surah == null) {
              return const Center(
                child: Text('لم يتم العثور على بيانات لهذه الصفحة.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var ayah in ayahs) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' ${surah.name} الآية: ${ayah.numberInSurah}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Theme.of(context).primaryColor,
                              fontFamily: TextFontType.quranFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            ayah.text,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: TextFontType.quranFont,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            ayah.tafseer,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: TextFontType.cairoFont,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
