import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim/View/Reader/widget_Api/seek_bar.dart';
import 'package:muslim/widgets/container_custom.dart';
import 'package:quran/quran.dart' as quran;

class QuranicVersePlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late int surahNumber;
  late int verseNumber;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var bufferedPosition = Duration.zero.obs;

  QuranicVersePlayerController(
      {required this.surahNumber, required this.verseNumber}) {
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        stopAudio();
      }
    });
    _audioPlayer.setSource(
        UrlSource(quran.getAudioURLByVerse(surahNumber, verseNumber)));
  }

  Future<void> play() async {
    await _audioPlayer
        .play(UrlSource(quran.getAudioURLByVerse(surahNumber, verseNumber)));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  void stopAudio() {
    _audioPlayer.stop();
  }

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  Future<void> nextVerse() async {
    verseNumber++;
    _audioPlayer.setSource(
        UrlSource(quran.getAudioURLByVerse(surahNumber, verseNumber)));
    play();
  }

  Future<void> previousVerse() async {
    if (verseNumber > 1) {
      verseNumber--;
      _audioPlayer.setSource(
          UrlSource(quran.getAudioURLByVerse(surahNumber, verseNumber)));
      play();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

class QuranicVersePlayer extends StatelessWidget {
  const QuranicVersePlayer({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuranicVersePlayerController(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    ));
    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سورة ${quran.getSurahNameArabic(controller.surahNumber)} - الآية ${controller.verseNumber}',
            ),
            SizedBox(height: 10.0.h),
            Obx(() => SeekBar(
                  duration: controller.duration.value,
                  position: controller.position.value,
                  bufferedPosition: controller.bufferedPosition.value,
                  onChanged: (newPosition) {
                    controller._audioPlayer.seek(newPosition);
                  },
                )),
            SizedBox(height: 10.0.h),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  controller.previousVerse();
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  controller.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  controller.stopAudio();
                },
              ),
              Obx(() => IconButton(
                    icon: Icon(
                        controller.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      if (controller.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    },
                  )),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  controller.nextVerse();
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
