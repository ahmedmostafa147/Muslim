import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'radio_player_state.dart';

@injectable
class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  RadioPlayerCubit() : super(const RadioPlayerState());

  Future<void> play(String? url) async {
    if (url == null) return;

    emit(state.copyWith(status: RadioPlayerStatus.loading, isLoading: true));

    try {
      await _player.play(UrlSource(url));
      emit(state.copyWith(
        status: RadioPlayerStatus.playing,
        isPlaying: true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RadioPlayerStatus.error,
        isLoading: false,
        errorMessage: 'فشل تشغيل الراديو',
      ));
    }
  }

  Future<void> stop() async {
    emit(state.copyWith(isLoading: true));

    try {
      await _player.stop();
      emit(state.copyWith(
        status: RadioPlayerStatus.stopped,
        isPlaying: false,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> share(String name, String url) async {
    try {
      final result = await Share.share(
        'تستمع إلى $name على تطبيق المسلم: $url',
        subject: 'استمع إلى $name',
      );

      if (result.status == ShareResultStatus.success) {
        emit(state.copyWith(successMessage: 'تم مشاركة الراديو بنجاح'));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشلت عملية المشاركة'));
    }
  }

  void setSleepTimer(int minutes) {
    emit(state.copyWith(
      sleepDuration: minutes,
      countdown: minutes,
      successMessage: 'تم اختيار وقت النوم $minutes دقيقة بنجاح',
    ));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final newCountdown = state.countdown - 1;

      if (newCountdown <= 0) {
        timer.cancel();
        stop();
        emit(state.copyWith(countdown: 0, sleepDuration: 0));
      } else {
        emit(state.copyWith(countdown: newCountdown));
      }
    });
  }

  void cancelSleepTimer() {
    _timer?.cancel();
    emit(state.copyWith(
      countdown: 0,
      sleepDuration: 0,
      successMessage: 'تم إلغاء وقت النوم بنجاح',
    ));
  }

  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _player.dispose();
    return super.close();
  }
}
