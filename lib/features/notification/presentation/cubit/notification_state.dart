import 'package:equatable/equatable.dart';

enum NotificationStatus { initial, loaded }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final bool isNotificationOn;
  final bool isAzkarOn;
  final String? successMessage;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.isNotificationOn = false,
    this.isAzkarOn = false,
    this.successMessage,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    bool? isNotificationOn,
    bool? isAzkarOn,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      isAzkarOn: isAzkarOn ?? this.isAzkarOn,
      successMessage: clearMessages ? null : successMessage,
      errorMessage: clearMessages ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, isNotificationOn, isAzkarOn, successMessage, errorMessage];
}
