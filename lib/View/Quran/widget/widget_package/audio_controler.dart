import 'package:Muslim/View/Quran/widget/widget_Api/seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rxdart/rxdart.dart' as rxdart;

class QuranicVersePlayerController extends GetxController {
  final _audioPlayer = AudioPlayer();
  late int surahNumber;
  late int verseNumber;
  Duration defaultDuration = const Duration(milliseconds: 1);
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;

  QuranicVersePlayerController(
      {required this.surahNumber, required this.verseNumber}) {
    _audioPlayer.setUrl(quran.getAudioURLByVerse(surahNumber, verseNumber));

    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      isLoading.value = state.playing;
    });
  }
  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  void play() async {
    await _audioPlayer.play();
  }

  void pause() async {
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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'سورة ${quran.getSurahNameArabic(controller.surahNumber)} - الآية ${controller.verseNumber}',
          ),
          SizedBox(height: 10.0.h),
          Obx(() => Column(
                children: [
                  StreamBuilder<PositionData>(
                    stream: controller._positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ??
                            controller.defaultDuration,
                        position: positionData?.position ??
                            controller.defaultDuration,
                        bufferedPosition: positionData?.bufferedPosition ??
                            controller.defaultDuration,
                        onChanged: (newPosition) {
                          controller.seek(newPosition);
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_outlined),
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
                        icon: Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40.r,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next_outlined),
                        onPressed: controller.playNextVerse,
                      ),
                      IconButton(
                        icon: const Icon(Icons.repeat),
                        onPressed: controller.repeatVerse,
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: controller.stopAudio,
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
