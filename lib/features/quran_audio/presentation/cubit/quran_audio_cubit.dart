import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'quran_audio_state.dart';

@injectable
class QuranAudioCubit extends Cubit<QuranAudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ItemScrollController itemScrollController = ItemScrollController();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;

  QuranAudioCubit() : super(const QuranAudioState()) {
    _initListeners();
  }

  void _initListeners() {
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      emit(state.copyWith(position: position));
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      emit(state.copyWith(duration: duration));
    });

    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
      switch (playerState) {
        case PlayerState.playing:
          emit(state.copyWith(status: QuranAudioStatus.playing));
          break;
        case PlayerState.paused:
          emit(state.copyWith(status: QuranAudioStatus.paused));
          break;
        case PlayerState.stopped:
          emit(state.copyWith(status: QuranAudioStatus.stopped));
          break;
        case PlayerState.completed:
          emit(state.copyWith(status: QuranAudioStatus.stopped));
          break;
        case PlayerState.disposed:
          break;
      }
    });
  }

  void setVerse(
      int surahNumber, int verseNumber, String verseText, String surahName) {
    emit(state.copyWith(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      verseText: verseText,
      surahName: surahName,
    ));
  }

  void togglePlayerVisibility() {
    emit(state.copyWith(isPlayerVisible: !state.isPlayerVisible));
  }

  Future<void> play() async {
    emit(state.copyWith(status: QuranAudioStatus.loading));
    try {
      final formattedSurah = state.surahNumber.toString().padLeft(3, '0');
      final formattedVerse = state.verseNumber.toString().padLeft(3, '0');
      final url =
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$formattedSurah$formattedVerse.mp3';

      await _audioPlayer.play(UrlSource(url));
      emit(state.copyWith(status: QuranAudioStatus.playing));
    } catch (e) {
      emit(state.copyWith(
        status: QuranAudioStatus.error,
        errorMessage: 'فشل تشغيل الصوت',
      ));
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    emit(state.copyWith(status: QuranAudioStatus.paused));
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      status: QuranAudioStatus.stopped,
      position: Duration.zero,
    ));
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNextVerse() async {
    emit(state.copyWith(verseNumber: state.verseNumber + 1));
    await play();
  }

  Future<void> playPreviousVerse() async {
    if (state.verseNumber > 1) {
      emit(state.copyWith(verseNumber: state.verseNumber - 1));
      await play();
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
