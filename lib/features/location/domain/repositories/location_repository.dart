import '../entities/location_entity.dart';

/// Abstract repository for location operations
abstract class LocationRepository {
  /// Get current device location
  Future<LocationEntity> getCurrentLocation();

  /// Get saved location from storage
  Future<LocationEntity> getSavedLocation();

  /// Save location to storage
  Future<void> saveLocation(LocationEntity location);
}
