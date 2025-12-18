import 'package:equatable/equatable.dart';

enum RadioPlayerStatus { initial, loading, playing, stopped, error }

class RadioPlayerState extends Equatable {
  final RadioPlayerStatus status;
  final bool isPlaying;
  final bool isLoading;
  final int sleepDuration;
  final int countdown;
  final String? successMessage;
  final String? errorMessage;

  const RadioPlayerState({
    this.status = RadioPlayerStatus.initial,
    this.isPlaying = false,
    this.isLoading = false,
    this.sleepDuration = 0,
    this.countdown = 0,
    this.successMessage,
    this.errorMessage,
  });

  RadioPlayerState copyWith({
    RadioPlayerStatus? status,
    bool? isPlaying,
    bool? isLoading,
    int? sleepDuration,
    int? countdown,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return RadioPlayerState(
      status: status ?? this.status,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      countdown: countdown ?? this.countdown,
      successMessage: clearMessages ? null : successMessage,
      errorMessage: clearMessages ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPlaying,
        isLoading,
        sleepDuration,
        countdown,
        successMessage,
        errorMessage
      ];
}
