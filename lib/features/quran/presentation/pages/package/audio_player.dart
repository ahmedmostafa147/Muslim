import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/quran_audio_cubit.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/quran_audio_state.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioCubit, QuranAudioState>(
      builder: (context, state) {
        if (!state.isPlayerVisible) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${state.surahName} - الآية ${state.verseNumber}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context
                        .read<QuranAudioCubit>()
                        .togglePlayerVisibility(),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                ),
                child: Slider(
                  value: state.position.inSeconds.toDouble(),
                  max: state.duration.inSeconds.toDouble() > 0
                      ? state.duration.inSeconds.toDouble()
                      : 1,
                  onChanged: (value) {
                    context
                        .read<QuranAudioCubit>()
                        .seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(state.position),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text(
                    _formatDuration(state.duration),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () =>
                        context.read<QuranAudioCubit>().playPreviousVerse(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        state.status == QuranAudioStatus.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (state.status == QuranAudioStatus.playing) {
                          context.read<QuranAudioCubit>().pause();
                        } else {
                          context.read<QuranAudioCubit>().play();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () =>
                        context.read<QuranAudioCubit>().playNextVerse(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
