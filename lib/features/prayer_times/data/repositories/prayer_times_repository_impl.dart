import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';

@Injectable(as: PrayerTimesRepository)
class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final SharedPreferences _prefs;

  PrayerTimesRepositoryImpl(this._prefs);

  static const String _cacheKey = 'cachedPrayerTimes';
  static const int _cacheDurationDays = 30;

  @override
  Future<PrayerTimesEntity> fetchPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    required String calculationMethod,
    required String madhab,
  }) async {
    final school = madhab == 'Shafi' ? '0' : '1';
    final url = Uri.parse(
      'http://api.aladhan.com/v1/calendar/${date.year}/${date.month}'
      '?latitude=$latitude&longitude=$longitude'
      '&method=$calculationMethod&school=$school',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final timings = data[date.day - 1]['timings'];

      // Format times
      return PrayerTimesEntity(
        fajr: _formatTime(timings['Fajr']),
        dhuhr: _formatTime(timings['Dhuhr']),
        asr: _formatTime(timings['Asr']),
        maghrib: _formatTime(timings['Maghrib']),
        isha: _formatTime(timings['Isha']),
        sunrise: _formatTime(timings['Sunrise']),
        sunset: _formatTime(timings['Sunset']),
        imsak: _formatTime(timings['Imsak']),
        midnight: _formatTime(timings['Midnight']),
      );
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  String _formatTime(String time) {
    try {
      final DateTime dateTime = DateFormat('HH:mm').parse(time.substring(0, 5));
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  @override
  Future<PrayerTimesEntity?> getCachedPrayerTimes() async {
    final cachedData = _prefs.getString(_cacheKey);
    if (cachedData == null) return null;

    final data = json.decode(cachedData);
    final cacheTimestamp =
        DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    final currentTime = DateTime.now();

    // Check if cache is still valid (within 30 days)
    if (currentTime.difference(cacheTimestamp).inDays <= _cacheDurationDays) {
      return PrayerTimesEntity.fromJson(data['prayerTimes']);
    }

    return null;
  }

  @override
  Future<void> cachePrayerTimes(
    PrayerTimesEntity prayerTimes,
    double latitude,
    double longitude,
  ) async {
    final data = {
      'prayerTimes': prayerTimes.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(_cacheKey, json.encode(data));
  }

  @override
  Future<bool> isLocationChanged(double latitude, double longitude) async {
    final cachedData = _prefs.getString(_cacheKey);
    if (cachedData == null) return true;

    final data = json.decode(cachedData);
    final cachedLatitude = data['latitude'] as double?;
    final cachedLongitude = data['longitude'] as double?;

    return latitude != cachedLatitude || longitude != cachedLongitude;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
