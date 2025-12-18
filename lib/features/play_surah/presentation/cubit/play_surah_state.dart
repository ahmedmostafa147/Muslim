import 'package:equatable/equatable.dart';

enum PlaySurahStatus { initial, loading, playing, paused, stopped, error }

class PlaySurahState extends Equatable {
  final PlaySurahStatus status;
  final int surahNumber;
  final String surahName;
  final String readerName;
  final String moshafName;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isRepeating;
  final bool isMuted;
  final int sleepDuration;
  final int countdown;
  final String? errorMessage;

  const PlaySurahState({
    this.status = PlaySurahStatus.initial,
    this.surahNumber = 1,
    this.surahName = '',
    this.readerName = '',
    this.moshafName = '',
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isRepeating = false,
    this.isMuted = false,
    this.sleepDuration = 0,
    this.countdown = 0,
    this.errorMessage,
  });

  bool get isLoading => status == PlaySurahStatus.loading;
  bool get isPlaying => status == PlaySurahStatus.playing;

  PlaySurahState copyWith({
    PlaySurahStatus? status,
    int? surahNumber,
    String? surahName,
    String? readerName,
    String? moshafName,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isRepeating,
    bool? isMuted,
    int? sleepDuration,
    int? countdown,
    String? errorMessage,
  }) {
    return PlaySurahState(
      status: status ?? this.status,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      readerName: readerName ?? this.readerName,
      moshafName: moshafName ?? this.moshafName,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isRepeating: isRepeating ?? this.isRepeating,
      isMuted: isMuted ?? this.isMuted,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      countdown: countdown ?? this.countdown,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        surahNumber,
        surahName,
        readerName,
        moshafName,
        currentPosition,
        totalDuration,
        isRepeating,
        isMuted,
        sleepDuration,
        countdown,
        errorMessage,
      ];
}
