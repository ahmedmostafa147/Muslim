class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;
  final String sunset;
  final String imsak;
  final String midnight;

  PrayerTimes(
      {required this.fajr,
      required this.dhuhr,
      required this.asr,
      required this.maghrib,
      required this.isha,
      required this.sunrise,
      required this.sunset,
      required this.imsak,
      required this.midnight});

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      sunrise: json['Sunrise'],
      sunset: json['Sunset'],
      imsak: json['Imsak'],
      midnight: json['Midnight'],
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      "Sunset": sunset,
      'Maghrib': maghrib,
      'Isha': isha,
      'Imsak': imsak,
      'Midnight': midnight
    };
  }
}