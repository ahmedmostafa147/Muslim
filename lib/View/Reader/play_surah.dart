import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Core/constant/images.dart';
import '../../Core/constant/themes.dart';
import '../../features/play_surah/presentation/cubit/play_surah_cubit.dart';
import '../../features/play_surah/presentation/cubit/play_surah_state.dart';
import '../../Models/api_reciters.dart';
import 'seek_bar.dart';
import '../../widgets/loading_widget.dart';

class PlaySurah extends StatelessWidget {
  final String surahUrl;
  final String surahName;
  final String readerName;
  final String moshafName;
  final int surahId;
  final Moshaf moshaf;
  final Reciter reciter;

  const PlaySurah({
    super.key,
    required this.surahUrl,
    required this.surahName,
    required this.readerName,
    required this.moshafName,
    required this.surahId,
    required this.moshaf,
    required this.reciter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaySurahCubit(
        initialSurahUrl: surahUrl,
        initialSurahNumber: surahId,
        readerName: readerName,
        moshafName: moshafName,
        serverUrl: moshaf.server ?? '',
      ),
      child: _PlaySurahView(readerName: readerName, moshafName: moshafName),
    );
  }
}

class _PlaySurahView extends StatelessWidget {
  final String readerName;
  final String moshafName;

  const _PlaySurahView({required this.readerName, required this.moshafName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإستماع للقرآن الكريم")),
      body: BlocBuilder<PlaySurahCubit, PlaySurahState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 250.h,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(Assets.imagesQuranforselecte),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "الشيخ $readerName",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.sp,
                      fontFamily: TextFontType.arefRuqaaFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text("( $moshafName )", style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 5.h),
                  Text(
                    "سورة ${state.surahName}",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: TextFontType.quranFont,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.r),
                    child: SeekBar(
                      duration: state.totalDuration,
                      position: state.currentPosition,
                      bufferedPosition: state.currentPosition,
                      onChanged: (newPosition) {
                        context.read<PlaySurahCubit>().seek(newPosition);
                      },
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.read<PlaySurahCubit>().nextSurah(),
                                icon: const Icon(Icons.skip_next),
                              ),
                              state.isLoading
                                  ? const LoadingWidget()
                                  : IconButton(
                                      onPressed: () {
                                        if (state.isPlaying) {
                                          context
                                              .read<PlaySurahCubit>()
                                              .pause();
                                        } else {
                                          context.read<PlaySurahCubit>().play();
                                        }
                                      },
                                      icon: Icon(
                                        state.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                              IconButton(
                                onPressed: () => context
                                    .read<PlaySurahCubit>()
                                    .previousSurah(),
                                icon: const Icon(Icons.skip_previous),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<PlaySurahCubit>()
                                    .skipBackward(),
                                icon: const Icon(Icons.forward_10),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<PlaySurahCubit>()
                                    .skipForward(),
                                icon: const Icon(Icons.replay_10),
                              ),
                              IconButton(
                                onPressed: () =>
                                    context.read<PlaySurahCubit>().replay(),
                                icon: const Icon(Icons.replay_outlined),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (state.isRepeating) {
                                    context.read<PlaySurahCubit>().stopRepeat();
                                  } else {
                                    context.read<PlaySurahCubit>().repeat();
                                  }
                                },
                                icon: Icon(
                                  state.isRepeating
                                      ? Icons.repeat_one
                                      : Icons.repeat,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state.isMuted) {
                                    context.read<PlaySurahCubit>().unmute();
                                  } else {
                                    context.read<PlaySurahCubit>().mute();
                                  }
                                },
                                icon: Icon(
                                  state.isMuted
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showTimerBottomSheet(context, state),
                                icon: const Icon(Icons.timer_outlined),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTimerBottomSheet(BuildContext context, PlaySurahState state) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PlaySurahCubit>(),
        child: _BottomSheetTimer(state: state),
      ),
    );
  }
}

class _BottomSheetTimer extends StatelessWidget {
  final PlaySurahState state;

  const _BottomSheetTimer({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? ColorsStyleApp.darkBackground
            : ColorsStyleApp.lightBackground,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("وقت النوم"),
            if (state.countdown > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "تبقى ${state.countdown} دقيقة للنوم",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            for (int minutes in [5, 15, 30, 45, 60])
              InkWell(
                onTap: () {
                  context.read<PlaySurahCubit>().sleep(minutes);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("تم اختيار وقت النوم $minutes دقيقة بنجاح")),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0.h),
                  child: Text(
                    '$minutes دقيقة',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (state.sleepDuration > 0)
              InkWell(
                onTap: () {
                  context.read<PlaySurahCubit>().cancelSleep();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم إلغاء وقت النوم بنجاح")),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: const Text(
                    'إلغاء وقت النوم',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
