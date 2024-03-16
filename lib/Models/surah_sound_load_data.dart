import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Surah {
  int? number;
  String? name;
  String? englishName;
  int? numberOfAyahs;
  String? revelationType;

  Surah({
    this.number,
    this.name,
    this.englishName,
    this.numberOfAyahs,
    this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
    };
  }
}

class SurahSoundLoadData {
  Future<List<Surah>> getSurah() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const url = "http://api.alquran.cloud/v1/surah";

    if (prefs.containsKey('surahList')) {
      // Return cached data if available
      final cachedData = prefs.getString('surahList');
      final List<dynamic> jsonResponse = jsonDecode(cachedData!);
      return jsonResponse.map((item) => Surah.fromJson(item)).toList();
    } else {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        List<Surah> list = [];

        json['data'].forEach((element) {
          if (list.length < 114) {
            list.add(Surah.fromJson(element));
          }
        });
        // Cache data locally
        await prefs.setString('surahList', jsonEncode(list));

        return list;
      } else {
        throw Exception('Failed to load Surah');
      }
    }
  }
}
