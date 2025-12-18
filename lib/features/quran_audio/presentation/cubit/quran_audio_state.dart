import 'package:equatable/equatable.dart';

enum QuranAudioStatus { initial, loading, playing, paused, stopped, error }

class QuranAudioState extends Equatable {
  final QuranAudioStatus status;
  final int surahNumber;
  final int verseNumber;
  final String verseText;
  final String surahName;
  final bool isPlayerVisible;
  final Duration position;
  final Duration duration;
  final String? errorMessage;

  const QuranAudioState({
    this.status = QuranAudioStatus.initial,
    this.surahNumber = 1,
    this.verseNumber = 1,
    this.verseText = '',
    this.surahName = '',
    this.isPlayerVisible = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  QuranAudioState copyWith({
    QuranAudioStatus? status,
    int? surahNumber,
    int? verseNumber,
    String? verseText,
    String? surahName,
    bool? isPlayerVisible,
    Duration? position,
    Duration? duration,
    String? errorMessage,
  }) {
    return QuranAudioState(
      status: status ?? this.status,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      verseText: verseText ?? this.verseText,
      surahName: surahName ?? this.surahName,
      isPlayerVisible: isPlayerVisible ?? this.isPlayerVisible,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        surahNumber,
        verseNumber,
        verseText,
        surahName,
        isPlayerVisible,
        position,
        duration,
        errorMessage,
      ];
}
