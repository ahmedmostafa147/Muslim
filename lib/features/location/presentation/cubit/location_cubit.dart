import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/location_repository.dart';
import 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;

  LocationCubit(this._repository) : super(const LocationState());

  /// Initialize by loading saved location
  Future<void> init() async {
    try {
      final location = await _repository.getSavedLocation();
      emit(state.copyWith(
        status: LocationStatus.loaded,
        location: location,
      ));
    } catch (e) {
      // Use default location on error
      emit(state.copyWith(status: LocationStatus.loaded));
    }
  }

  /// Get current device location
  Future<void> getCurrentLocation() async {
    emit(state.copyWith(
      isLoading: true,
      clearMessages: true,
    ));

    try {
      final location = await _repository.getCurrentLocation();
      emit(state.copyWith(
        status: LocationStatus.loaded,
        location: location,
        isLoading: false,
        successMessage: 'تم تحديد الموقع الحالي بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LocationStatus.error,
        isLoading: false,
        errorMessage: 'حدث خطأ أثناء تحديد الموقع الحالي',
      ));
    }
  }

  /// Clear any displayed messages
  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }
}
