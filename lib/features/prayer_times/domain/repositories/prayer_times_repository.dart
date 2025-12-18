import '../entities/prayer_times_entity.dart';

/// Abstract repository for prayer times operations
abstract class PrayerTimesRepository {
  /// Fetch prayer times from API
  Future<PrayerTimesEntity> fetchPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    required String calculationMethod,
    required String madhab,
  });

  /// Get cached prayer times
  Future<PrayerTimesEntity?> getCachedPrayerTimes();

  /// Cache prayer times
  Future<void> cachePrayerTimes(
    PrayerTimesEntity prayerTimes,
    double latitude,
    double longitude,
  );

  /// Check if location has changed from cached
  Future<bool> isLocationChanged(double latitude, double longitude);

  /// Clear cache
  Future<void> clearCache();
}
