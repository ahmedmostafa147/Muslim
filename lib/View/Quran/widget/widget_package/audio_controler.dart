import '../widget_Api/seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rxdart/rxdart.dart' as rxdart;

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class QuranicVersePlayerController extends GetxController {
  final _audioPlayer = AudioPlayer();
  late int surahNumber;
  late int verseNumber;
  final defaultDuration = const Duration(milliseconds: 1);
  final isPlaying = false.obs;
  final isLoading = false.obs;

  late final _positionDataStream =
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    _audioPlayer.positionStream,
    _audioPlayer.bufferedPositionStream,
    _audioPlayer.durationStream,
    (position, bufferedPosition, duration) =>
        PositionData(position, bufferedPosition, duration ?? Duration.zero),
  );

  QuranicVersePlayerController(
      {required this.surahNumber, required this.verseNumber}) {
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(quran.getAudioURLByVerse(surahNumber, verseNumber))));
    _audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;
    });
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  void playNextVerse() {
    if (verseNumber < quran.getVerseCount(surahNumber)) {
      verseNumber++;
      _audioPlayer.setUrl(quran.getAudioURLByVerse(surahNumber, verseNumber));
    }
  }

  void repeatVerse() {
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();
  }

  void playPreviousVerse() {
    if (verseNumber > 1) {
      verseNumber--;
      _audioPlayer.setUrl(quran.getAudioURLByVerse(surahNumber, verseNumber));
    }
  }

  void stopAudio() {
    _audioPlayer.stop();
  }

  void seek(Duration duration) {
    _audioPlayer.seek(duration);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

class QuranicVersePlayer extends StatelessWidget {
  const QuranicVersePlayer({
    Key? key,
    required this.surahNumber,
    required this.verseNumber,
  }) : super(key: key);

  final int surahNumber;
  final int verseNumber;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuranicVersePlayerController(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    ));
    return Container(
        height: 200.h,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سورة ${quran.getSurahNameArabic(controller.surahNumber)} - الآية ${controller.verseNumber}',
            ),
            SizedBox(height: 10.0.h),
            StreamBuilder<PositionData>(
              stream: controller._positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration:
                      positionData?.duration ?? controller.defaultDuration,
                  position:
                      positionData?.position ?? controller.defaultDuration,
                  bufferedPosition: positionData?.bufferedPosition ??
                      controller.defaultDuration,
                  onChanged: (newPosition) {
                    controller.seek(newPosition);
                  },
                );
              },
            ),
            SizedBox(height: 10.0.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_next_sharp),
                    onPressed: controller.playPreviousVerse,
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.isPlaying.value) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    },
                    icon: Obx(() => Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40.r,
                        )),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_sharp),
                    onPressed: controller.playNextVerse,
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: controller.repeatVerse,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: controller.stopAudio,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
