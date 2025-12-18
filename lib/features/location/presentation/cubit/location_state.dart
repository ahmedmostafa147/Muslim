import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';

enum LocationStatus { initial, loading, loaded, error }

class LocationState extends Equatable {
  final LocationStatus status;
  final LocationEntity location;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const LocationState({
    this.status = LocationStatus.initial,
    this.location = LocationEntity.defaultLocation,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  LocationState copyWith({
    LocationStatus? status,
    LocationEntity? location,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return LocationState(
      status: status ?? this.status,
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [status, location, isLoading, successMessage, errorMessage];
}
