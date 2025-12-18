import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/di/injection.dart';
import '../../../Core/constant/themes.dart';
import '../../../features/tafseer/presentation/cubit/tafseer_cubit.dart';
import '../../../features/tafseer/presentation/cubit/tafseer_state.dart';

class TafseerScreenPackage extends StatelessWidget {
  final int surahIndex;

  const TafseerScreenPackage({super.key, required this.surahIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TafseerCubit>(),
      child: _TafseerView(surahNumber: surahIndex),
    );
  }
}

class _TafseerView extends StatelessWidget {
  final int surahNumber;

  const _TafseerView({required this.surahNumber});

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

            final surah = state.getSurahByNumber(surahNumber);

            if (surah == null) {
              return const Center(
                child: Text('لم يتم العثور على بيانات لهذه السورة.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var ayah in surah.ayahs) ...[
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
