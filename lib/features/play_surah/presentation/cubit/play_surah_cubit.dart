import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart' as quran;

import 'play_surah_state.dart';

class PlaySurahCubit extends Cubit<PlaySurahState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String initialSurahUrl;
  final int initialSurahNumber;
  final String serverUrl;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  Timer? _sleepTimer;
  Timer? _countdownTimer;

  PlaySurahCubit({
    required this.initialSurahUrl,
    required this.initialSurahNumber,
    required String readerName,
    required String moshafName,
    required this.serverUrl,
  }) : super(PlaySurahState(
          surahNumber: initialSurahNumber,
          surahName: quran.getSurahNameArabic(initialSurahNumber),
          readerName: readerName,
          moshafName: moshafName,
        )) {
    _initListeners();
    _loadAndPlay(initialSurahUrl);
  }

  void _initListeners() {
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      emit(state.copyWith(currentPosition: position));
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      emit(state.copyWith(totalDuration: duration));
    });

    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
      switch (playerState) {
        case PlayerState.playing:
          emit(state.copyWith(status: PlaySurahStatus.playing));
          break;
        case PlayerState.paused:
          emit(state.copyWith(status: PlaySurahStatus.paused));
          break;
        case PlayerState.stopped:
          emit(state.copyWith(status: PlaySurahStatus.stopped));
          break;
        case PlayerState.completed:
          if (state.isRepeating) {
            play();
          } else {
            nextSurah();
          }
          break;
        case PlayerState.disposed:
          break;
      }
    });
  }

  Future<void> _loadAndPlay(String url) async {
    emit(state.copyWith(status: PlaySurahStatus.loading));
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      emit(state.copyWith(
        status: PlaySurahStatus.error,
        errorMessage: 'فشل تشغيل الصوت',
      ));
    }
  }

  Future<void> play() async {
    final url = _getSurahUrl(state.surahNumber);
    await _loadAndPlay(url);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      status: PlaySurahStatus.stopped,
      currentPosition: Duration.zero,
    ));
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void skipForward() {
    final newPosition = state.currentPosition + const Duration(seconds: 10);
    if (newPosition < state.totalDuration) {
      seek(newPosition);
    }
  }

  void skipBackward() {
    final newPosition = state.currentPosition - const Duration(seconds: 10);
    seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void nextSurah() {
    if (state.surahNumber < 114) {
      final newSurahNumber = state.surahNumber + 1;
      emit(state.copyWith(
        surahNumber: newSurahNumber,
        surahName: quran.getSurahNameArabic(newSurahNumber),
      ));
      play();
    }
  }

  void previousSurah() {
    if (state.surahNumber > 1) {
      final newSurahNumber = state.surahNumber - 1;
      emit(state.copyWith(
        surahNumber: newSurahNumber,
        surahName: quran.getSurahNameArabic(newSurahNumber),
      ));
      play();
    }
  }

  void replay() {
    seek(Duration.zero);
    play();
  }

  void repeat() {
    emit(state.copyWith(isRepeating: true));
  }

  void stopRepeat() {
    emit(state.copyWith(isRepeating: false));
  }

  void mute() {
    _audioPlayer.setVolume(0);
    emit(state.copyWith(isMuted: true));
  }

  void unmute() {
    _audioPlayer.setVolume(1);
    emit(state.copyWith(isMuted: false));
  }

  void sleep(int minutes) {
    emit(state.copyWith(sleepDuration: minutes, countdown: minutes));
    _countdownTimer?.cancel();
    _sleepTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final newCountdown = state.countdown - 1;
      if (newCountdown <= 0) {
        timer.cancel();
      }
      emit(state.copyWith(countdown: newCountdown));
    });

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      pause();
      emit(state.copyWith(sleepDuration: 0, countdown: 0));
    });
  }

  void cancelSleep() {
    _sleepTimer?.cancel();
    _countdownTimer?.cancel();
    emit(state.copyWith(sleepDuration: 0, countdown: 0));
  }

  String _getSurahUrl(int surahNumber) {
    final formattedSurah = surahNumber.toString().padLeft(3, '0');
    return '$serverUrl$formattedSurah.mp3';
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _sleepTimer?.cancel();
    _countdownTimer?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
