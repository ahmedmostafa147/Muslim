import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/di/injection.dart';
import '../features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'loading_widget.dart';
import '../Core/constant/images.dart';

class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrayerTimesCubit>()..init(),
      child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          if (state.prayerTimes == null) {
            return const Center(child: LoadingWidget());
          }

          return ListView(
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildPrayerTimeItemRow(
                    name: 'الفجر',
                    imagePath: Assets.imagesFajr,
                    time: state.prayerTimes!.fajr,
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'الظهر',
                    imagePath: Assets.imagesDhuhr,
                    time: state.prayerTimes!.dhuhr,
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'العصر',
                    imagePath: Assets.imagesAsr,
                    time: state.prayerTimes!.asr,
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'المغرب',
                    imagePath: Assets.imagesMaghrib,
                    time: state.prayerTimes!.maghrib,
                  ),
                  BuildPrayerTimeItemRow(
                    name: 'العشاء',
                    imagePath: Assets.imagesIsha,
                    time: state.prayerTimes!.isha,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class BuildPrayerTimeItemRow extends StatelessWidget {
  final String name;
  final String imagePath;
  final String time;

  const BuildPrayerTimeItemRow({
    super.key,
    required this.name,
    required this.imagePath,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 40.h, width: 40.w, child: Image.asset(imagePath)),
        Text(
          name,
          style: TextStyle(fontSize: 12.sp),
        ),
        Text(
          time,
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }
}
