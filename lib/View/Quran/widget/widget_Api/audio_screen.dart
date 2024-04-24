import 'dart:async';
import '../../../../Core/constant/style.dart';

import '../../../../Models/reader_load_data.dart';
import '../../../../Models/surah_sound_load_data.dart';
import 'seek_bar.dart';
import '../../../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:just_audio_background/just_audio_background.dart';

class AudioController extends GetxController {
  final _player = AudioPlayer();
  late Duration defaultDuration;
  String? ind;
  var currentIndex = 0.obs;
  var dataIndex = 0.obs;
  final Reader reader;
  final int index;
  final List<Surah>? list;
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var sleepDuration = 0.obs;
  var countdown = 0.obs;
  late Timer timer;

  AudioController({
    required this.reader,
    required this.index,
    required this.list,
  });

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = index - 1;
    dataIndex.value = index - 1;
    defaultDuration = const Duration(milliseconds: 1);

    if (index < 10) {
      ind = "00$index";
    } else if (index < 100) {
      ind = "0$index";
    } else if (index > 100) {
      ind = index.toString();
    }
    _initAudioPlayer(ind!, reader);
   
  }

 

  Future<void> _initAudioPlayer(
    String ind,
    Reader reader,
  ) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {
      final processingState = event.processingState;
      if (processingState == ProcessingState.completed) {}
      if (processingState == ProcessingState.loading) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }
    }, onError: (Object e, StackTrace stackTrace) {});

    try {
      var url =
          "https://download.quranicaudio.com/quran/${reader.relativePath}$ind.mp3";

      defaultDuration =
          (await _player.setAudioSource(AudioSource.uri(Uri.parse(url),
              tag: MediaItem(
                id: url,
                album: reader.name,
                title: list![currentIndex.value].name!,
                genre: reader.name,
              ))))!;
    } catch (e) {}
  }

  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
              position, bufferedPosition, duration ?? Duration.zero);
        },
      );

  void play() {
    _player.play();
    isPlaying.value = true;
  }

  void pause() async {
    _player.pause();
    isPlaying.value = false;
    isLoading.value = false;
  }

  void replay() async {
    await _player.seek(Duration.zero);
    isPlaying.value = true;
    isLoading.value = false;
  }

  void seek(Duration position) => _player.seek(position);

  void skipPrevious() {
    if (currentIndex.value < list!.length - 1) {
      currentIndex.value++;
      dataIndex.value++;
      if (currentIndex.value < 10) {
        ind = "00${currentIndex.value + 1}";
      } else if (currentIndex.value < 100) {
        ind = "0${currentIndex.value + 1}";
      } else if (currentIndex.value > 100) {
        ind = (currentIndex.value + 1).toString();
      }
      _initAudioPlayer(ind!, reader);
    }
  }

  void skipNext() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      dataIndex.value--;
      if (currentIndex.value < 10) {
        ind = "00${currentIndex.value + 1}";
      } else if (currentIndex.value < 100) {
        ind = "0${currentIndex.value + 1}";
      } else if (currentIndex.value > 100) {
        ind = (currentIndex.value + 1).toString();
      }
      _initAudioPlayer(ind!, reader);
    }
  }

  void sleep(int minutes) async {
    sleepDuration.value = minutes;
    countdown.value = minutes;
    timer = Timer.periodic(
      const Duration(
        minutes: 1,
      ),
      (timer) {
        countdown.value--;
        if (countdown.value <= 0) {
          timer.cancel();
          pause();
        }
      },
    );
  }

  void cancelSleep() {
    countdown.value = 0;
    timer.cancel();
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}

class AudioScreen extends StatelessWidget {
  final Reader reader;
  final int index;
  final List<Surah>? list;

  const AudioScreen({
    super.key,
    required this.reader,
    required this.index,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController(
      reader: reader,
      index: index,
      list: list,
    ));
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? ColorsStyleApp.darkBackground
          : ColorsStyleApp.lightBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      controller
                          .list![controller.currentIndex.value].englishName!,
                      style: TextStyle(
                        fontFamily: TextFontType.quranFont,
                        fontSize: 15.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.list![controller.currentIndex.value].name!,
                      style: TextStyle(
                        fontFamily: TextFontType.quranFont,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: 10.h,
          ),
          StreamBuilder<PositionData>(
            stream: controller.positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return Material(
                type: MaterialType.transparency,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SeekBar(
                      duration:
                          positionData?.duration ?? controller.defaultDuration,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChanged: controller.seek,
                    )),
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.skipNext,
                  icon: const Icon(Icons.skip_next_outlined),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? const LoadingWidget()
                      : IconButton(
                          onPressed: () {
                            if (controller.isPlaying.value) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                          },
                          icon: Icon(
                            controller.isPlaying.value
                                ? Icons
                                    .pause // Change the icon to pause when playing

                                : Icons
                                    .play_arrow, // Change the icon to replay when stopped
                            size: 30.r,
                          ),
                        ),
                ),
                IconButton(
                  onPressed: controller.skipPrevious,
                  icon: const Icon(Icons.skip_previous_outlined),
                ),
                IconButton(
                  onPressed: controller.replay,
                  icon: const Icon(Icons.replay_outlined),
                ),
                IconButton(
                  onPressed: () {
                    Get.bottomSheet(const BottomSheetTimer());
                  },
                  icon: Icon(
                    Icons.timer_outlined,
                    size: 25.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetTimer extends StatelessWidget {
  const BottomSheetTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AudioController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? ColorsStyleApp.darkBackground
            : ColorsStyleApp.lightBackground,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("وقت النوم"),
            Obx(() {
              if (controller.countdown.value > 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "تبقى ${controller.countdown.value} دقيقة للنوم",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            for (int minutes in [5, 15, 30, 45, 60])
              InkWell(
                onTap: () {
                  controller.sleep(minutes);
                  Get.back();
                  Get.snackbar(
                    "تم الاختيار",
                    "تم اختيار وقت النوم $minutes دقيقة بنجاح",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0.h),
                  child: Text(
                    '$minutes دقيقة',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (controller.sleepDuration.value > 0)
              InkWell(
                onTap: () {
                  controller.cancelSleep();
                  Get.back();
                  Get.snackbar(
                    "تم الإلغاء",
                    "تم إلغاء وقت النوم بنجاح",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: const Text(
                    'إلغاء وقت النوم',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
