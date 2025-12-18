import 'package:equatable/equatable.dart';

/// Entity representing prayer times for a day
class PrayerTimesEntity extends Equatable {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;
  final String sunset;
  final String imsak;
  final String midnight;

  const PrayerTimesEntity({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.sunset,
    required this.imsak,
    required this.midnight,
  });

  factory PrayerTimesEntity.fromJson(Map<String, dynamic> json) {
    return PrayerTimesEntity(
      fajr: json['Fajr'] ?? '',
      dhuhr: json['Dhuhr'] ?? '',
      asr: json['Asr'] ?? '',
      maghrib: json['Maghrib'] ?? '',
      isha: json['Isha'] ?? '',
      sunrise: json['Sunrise'] ?? '',
      sunset: json['Sunset'] ?? '',
      imsak: json['Imsak'] ?? '',
      midnight: json['Midnight'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
      'Sunrise': sunrise,
      'Sunset': sunset,
      'Imsak': imsak,
      'Midnight': midnight,
    };
  }

  @override
  List<Object?> get props =>
      [fajr, dhuhr, asr, maghrib, isha, sunrise, sunset, imsak, midnight];
}
