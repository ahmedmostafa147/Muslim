import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:muslim/Models/api_reciters.dart';

class PlaySurahController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var isRepeating = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var surahUrl = ''.obs;
  var surahName = ''.obs;
  final String readerName;
  final String moshafName;
  final Moshaf moshaf;
  final Reciter reciter;
  var surahNumber = 0.obs;
  var sleepDuration = 0.obs;
  var countdown = 0.obs;
  Timer? timer;

  PlaySurahController({
    required this.moshaf,
    required this.reciter,
    required String initialSurahUrl,
    required this.readerName,
    required this.moshafName,
    required int initialSurahNumber,
  }) {
    surahUrl.value = initialSurahUrl;
    surahNumber.value = initialSurahNumber;
    surahName.value = quran.getSurahNameArabic(surahNumber.value);
  }

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
      final formattedSurahUrl = generateSurahUrl(surahNumber.value);
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

  Future<void> repeat() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    isRepeating.value = true;
  }

  Future<void> stopRepeat() async {
    await _player.setReleaseMode(ReleaseMode.release);
    isRepeating.value = false;
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

  Future<void> nextVerse() async {
    try {
      isLoading.value = true;
      surahNumber.value++;
      surahName.value = quran.getSurahNameArabic(surahNumber.value);
      surahUrl.value = generateSurahUrl(surahNumber.value);

      await play();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> previousVerse() async {
    try {
      isLoading.value = true;
      surahNumber.value--;
      surahName.value = quran.getSurahNameArabic(surahNumber.value);
      surahUrl.value = generateSurahUrl(surahNumber.value);
      await play();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  String generateSurahUrl(int surahNumber) {
    return '${moshaf.server}${formatSurahNumber(surahNumber)}.mp3';
  }

  void sleep(int minutes) {
    sleepDuration.value = minutes;
    countdown.value = minutes;
    timer?.cancel();
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
    timer?.cancel();
  }

  @override
  void onClose() {
    _player.dispose();
    timer?.cancel();
    super.onClose();
  }
}