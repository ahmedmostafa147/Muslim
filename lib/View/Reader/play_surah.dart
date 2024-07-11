import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Core/constant/themes.dart';

class PlaySurahController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  final String surahUrl;
  final String surahName;

  var sleepDuration = 0.obs;
  var countdown = 0.obs;
  late Timer timer;

  PlaySurahController({
    required this.surahUrl,
    required this.surahName,
  });
  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _player.onDurationChanged.listen((newDuration) {
      totalDuration.value = newDuration;
    });
    _player.onPositionChanged.listen((newPosition) {
      currentPosition.value = newPosition;
    });
    _player.onPlayerComplete.listen((event) {
      isPlaying.value = false;
    });
    _player.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
    _player.onLog.listen((msg) {
      isLoading.value = false;
      Get.snackbar("Audio Player Error", msg);
    });
  }

  String formatSurahNumber(int number) {
    return number.toString().padLeft(3, '0');
  }

  Future<void> play() async {
    try {
      isLoading.value = true;
      final formattedSurahUrl =
          surahUrl.replaceAllMapped(RegExp(r'/(\d+)\.mp3'), (match) {
        final number = int.parse(match.group(1)!);
        return '/${formatSurahNumber(number)}.mp3';
      });
      await _player.play(UrlSource(formattedSurahUrl));
      isPlaying.value = true;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> replay() async {
    try {
      await _player.seek(Duration.zero);
      await play();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
      currentPosition.value = position;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void sleep(int minutes) async {
    sleepDuration.value = minutes;
    countdown.value = minutes;
    timer = Timer.periodic(
      const Duration(minutes: 1),
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

class PlaySurah extends StatelessWidget {
  final String surahUrl;
  final String surahName;

  const PlaySurah({
    super.key,
    required this.surahUrl,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlaySurahController(
      surahUrl: surahUrl,
      surahName: surahName,
    ));
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.surahName,
                      style: TextStyle(
                        fontFamily: 'QuranFont',
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.sp,
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
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            size: 30.r,
                          ),
                        ),
                        IconButton(
                          onPressed: controller.replay,
                          icon: const Icon(Icons.replay_outlined),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetTimer extends StatelessWidget {
  const BottomSheetTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlaySurahController>();
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
