import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Core/constant/images.dart';
import 'package:just_audio/just_audio.dart';
import '../../Core/constant/style.dart';
import '../../widgets/loading_widget.dart';
import 'package:share_plus/share_plus.dart';

class AudioPlayerController extends GetxController {
  final _player = AudioPlayer();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var sleepDuration = 0.obs;
  var countdown = 0.obs;
  late Timer timer;

  void play(String? url) async {
    if (url != null) {
      isLoading.value = true;
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _player.play();
      isPlaying.value = true;
      isLoading.value = false;
    }
  }

  void stop() async {
    isLoading.value = true;
    await _player.stop();
    isPlaying.value = false;
    isLoading.value = false;
  }

  void share(String name, String url) async {
    final result = await Share.shareWithResult(
      'تستمع إلى $name على تطبيق المسلم: $url',
      subject: 'استمع إلى $name',
    );
    if (result.status == ShareResultStatus.success) {
      Get.snackbar("نجح", "تم مشاركة الراديو بنجاح");
    } else {
      Get.snackbar("فشل", "فشلت عملية المشاركة");
    }
  }

  void sleep(int minutes) async {
    sleepDuration.value = minutes;
    countdown.value = minutes;
    timer = Timer.periodic(
        const Duration(
          minutes: 1,
        ), (timer) {
      countdown.value--;

      if (countdown.value <= 0) {
        timer.cancel();
        stop();
      }
    });
  }

  void cancelSleep() {
    countdown.value = 0;
    timer.cancel();
  }
}

class PlayRadio extends StatelessWidget {
  final String radioName;
  final String radioUrl;
  final String radioTitle;

  const PlayRadio(
      {super.key,
      required this.radioName,
      required this.radioUrl,
      required this.radioTitle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioPlayerController());
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller._player.dispose();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(radioTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  height: 250.h,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(Assets.imagesRadioLogo),
                      fit: BoxFit.contain,
                    ),
                  )),
              SizedBox(height: 10.h),
              const Spacer(),
              Text(
                radioName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? ColorsStyleApp.darkBackground
                      : ColorsStyleApp.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.share(radioName, radioUrl);
                      },
                      icon: Icon(
                        Icons.share,
                        size: 40.r,
                      ),
                    ),
                    Obx(() => controller.isLoading.value
                        ? const LoadingWidget()
                        : IconButton.outlined(
                            onPressed: () {
                              if (controller.isPlaying.value) {
                                controller.stop();
                              } else {
                                controller.play(radioUrl);
                              }
                            },
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              size: 40.r,
                            ),
                          )),
                    IconButton(
                        onPressed: () {
                          Get.bottomSheet(const BottomSheetTimer());
                        },
                        icon: Icon(
                          Icons.timer_outlined,
                          size: 40.r,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetTimer extends StatelessWidget {
  const BottomSheetTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AudioPlayerController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? ColorsStyleApp.darkBackground
            : ColorsStyleApp.lightBackground,
        borderRadius: BorderRadius.all(
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
                    style: TextStyle(
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
