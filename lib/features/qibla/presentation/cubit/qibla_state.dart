import 'package:equatable/equatable.dart';

enum QiblaStatus { initial, loading, loaded, error }

class QiblaState extends Equatable {
  final QiblaStatus status;
  final double qiblaDirection;
  final double deviceHeading;
  final String? errorMessage;

  const QiblaState({
    this.status = QiblaStatus.initial,
    this.qiblaDirection = 0.0,
    this.deviceHeading = 0.0,
    this.errorMessage,
  });

  QiblaState copyWith({
    QiblaStatus? status,
    double? qiblaDirection,
    double? deviceHeading,
    String? errorMessage,
  }) {
    return QiblaState(
      status: status ?? this.status,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      deviceHeading: deviceHeading ?? this.deviceHeading,
      errorMessage: errorMessage,
    );
  }

  /// Get the angle to rotate the compass needle
  double get needleAngle => qiblaDirection - deviceHeading;

  @override
  List<Object?> get props =>
      [status, qiblaDirection, deviceHeading, errorMessage];
}
