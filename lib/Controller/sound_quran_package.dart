import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran/quran.dart' as quran;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranicVersePlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var surahNumber = 0.obs;
  var verseNumber = 0.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var bufferedPosition = Duration.zero.obs;
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var isRepeating = false.obs;
  var currentVerse = 0.obs;
  var currentSurahName = ''.obs;
  var currentVerseText = ''.obs;
  var isAudioPlayerVisible = false.obs;

  QuranicVersePlayerController() {
    _setupAudioPlayer();
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  void scrollToActiveVerse() {
    itemScrollController.scrollTo(
      index: verseNumber.value - 1,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void setVerse(
      int surahIndex, int verseIndex, String verseText, String surahName) {
    surahNumber.value = surahIndex;
    verseNumber.value = verseIndex;
    currentVerseText.value = verseText;
    currentSurahName.value = surahName;
    _audioPlayer.setSourceUrl(
        quran.getAudioURLByVerse(surahNumber.value, verseNumber.value));
  }

  void toggleAudioPlayerVisibility() {
    isAudioPlayerVisible.value = !isAudioPlayerVisible.value;
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      if (isRepeating.value) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      } else {
        nextVerse();
      }
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  Future<void> play() async {
    isLoading.value = true;
    await _audioPlayer.play(UrlSource(
        quran.getAudioURLByVerse(surahNumber.value, verseNumber.value)));
    currentVerse.value = verseNumber.value;
    isLoading.value = false;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> repeat() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
    isRepeating.value = true;
  }

  Future<void> stopRepeat() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
    isRepeating.value = false;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    this.position.value = position;
  }

  Future<void> nextVerse() async {
    if (verseNumber.value < quran.getVerseCount(surahNumber.value)) {
      isLoading.value = true;
      verseNumber++;
      _audioPlayer.setSourceUrl(
          quran.getAudioURLByVerse(surahNumber.value, verseNumber.value));
      await play();
      currentVerse.value = verseNumber.value;
      isLoading.value = false;
    }
  }

  Future<void> previousVerse() async {
    if (verseNumber.value > 1) {
      isLoading.value = true;
      verseNumber--;
      _audioPlayer.setSourceUrl(
          quran.getAudioURLByVerse(surahNumber.value, verseNumber.value));
      await play();
      currentVerse.value = verseNumber.value;
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
