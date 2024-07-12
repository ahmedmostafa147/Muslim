import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/Controller/play_full_surah_controller.dart';
import 'package:muslim/Core/constant/images.dart';
import 'package:muslim/Core/constant/themes.dart';
import 'package:muslim/Models/api_reciters.dart';
import 'package:muslim/View/Reader/seek_bar.dart';
import 'package:muslim/widgets/container_custom.dart';

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
    final controller = Get.put(PlaySurahController(
      initialSurahUrl: surahUrl,
      readerName: readerName,
      moshafName: moshafName,
      initialSurahNumber: surahId,
      moshaf: moshaf,
      reciter: reciter,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("الإستماع للقرآن الكريم"),
      ),
      body: SingleChildScrollView(
        child: CustomContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                Assets.imagesRamdan,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      controller.surahName.value,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Text(
                    controller.readerName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    controller.moshafName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              Obx(
                () => SeekBar(
                  duration: controller.totalDuration.value,
                  position: controller.currentPosition.value,
                  bufferedPosition: controller.currentPosition.value,
                  onChanged: (newPosition) {
                    controller.seek(newPosition);
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: controller.previousVerse,
                                icon: const Icon(Icons.skip_previous),
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
                                ),
                              ),
                              IconButton(
                                onPressed: controller.nextVerse,
                                icon: const Icon(Icons.skip_next),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (controller.isRepeating.value) {
                                    controller.stopRepeat();
                                  } else {
                                    controller.repeat();
                                  }
                                },
                                icon: Icon(
                                  controller.isRepeating.value
                                      ? Icons.repeat_one
                                      : Icons.repeat,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.bottomSheet(const BottomSheetTimer());
                                },
                                icon: const Icon(Icons.timer_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement volume control here
                                },
                                icon: const Icon(Icons.volume_up_outlined),
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
