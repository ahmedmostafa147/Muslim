import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/sound_quran_package.dart';
import '../../Reader/seek_bar.dart';
import '../../../widgets/container_custom.dart';

class AudioPlayerWidget extends StatelessWidget {
  final QuranicVersePlayerController quranController;

  const AudioPlayerWidget({super.key, required this.quranController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (quranController.isAudioPlayerVisible.value) {
        return CustomContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.outlined(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      quranController.toggleAudioPlayerVisibility();
                    },
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                      'سورة ${quranController.currentSurahName.value} - الآية ${quranController.verseNumber.value}',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10.0.h),
              Obx(() => SeekBar(
                    duration: quranController.duration.value,
                    position: quranController.position.value,
                    bufferedPosition: quranController.bufferedPosition.value,
                    onChanged: (newPosition) {
                      quranController.seek(newPosition);
                    },
                  )),
              SizedBox(height: 10.0.h),
              if (quranController.isLoading.value)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_next_sharp),
                      onPressed: () {
                        quranController.nextVerse();
                        quranController.scrollToActiveVerse();
                      },
                    ),
                    IconButton(
                      icon: Icon(quranController.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () {
                        quranController.isPlaying.value
                            ? quranController.pause()
                            : quranController.play();
                        quranController.scrollToActiveVerse();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_sharp),
                      onPressed: () {
                        quranController.previousVerse();
                        quranController.scrollToActiveVerse();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: quranController.play,
                    ),
                    IconButton(
                      icon: Icon(quranController.isRepeating.value
                          ? Icons.repeat_on_sharp
                          : Icons.repeat),
                      onPressed: quranController.isRepeating.value
                          ? quranController.stopRepeat
                          : quranController.repeat,
                    ),
                  ],
                ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
