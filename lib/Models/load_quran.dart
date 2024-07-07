// File: models/quran.dart

import 'package:meta/meta.dart';
import 'dart:convert';

class Quran {
  final List<Datum> data;

  Quran({
    required this.data,
  });

  factory Quran.fromRawJson(String str) => Quran.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Quran.fromJson(Map<String, dynamic> json) => Quran(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final RevelationType? revelationType;
  final List<Ayah> ayahs;

  Datum({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        number: json["number"] ?? 0,
        name: json["name"] ?? "",
        englishName: json["englishName"] ?? "",
        englishNameTranslation: json["englishNameTranslation"] ?? "",
        revelationType: json["revelationType"] == null
            ? null
            : revelationTypeValues.map[json["revelationType"]],
        ayahs: json["ayahs"] == null
            ? []
            : List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationTypeValues.reverse[revelationType],
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
      };
}

class Ayah {
  final int number;
  final String text;
  final String tafseer;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.tafseer,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromRawJson(String str) => Ayah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json["number"] ?? 0,
        text: json["text"] ?? "",
        tafseer: json["tafseer"] ?? "",
        numberInSurah: json["numberInSurah"] ?? 0,
        juz: json["juz"] ?? 0,
        manzil: json["manzil"] ?? 0,
        page: json["page"] ?? 0,
        ruku: json["ruku"] ?? 0,
        hizbQuarter: json["hizbQuarter"] ?? 0,
        sajda: json["sajda"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "text": text,
        "tafseer": tafseer,
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda,
      };
}

class SajdaClass {
  final int id;
  final bool recommended;
  final bool obligatory;

  SajdaClass({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdaClass.fromRawJson(String str) =>
      SajdaClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SajdaClass.fromJson(Map<String, dynamic> json) => SajdaClass(
        id: json["id"] ?? 0,
        recommended: json["recommended"] ?? false,
        obligatory: json["obligatory"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recommended": recommended,
        "obligatory": obligatory,
      };
}

enum RevelationType { EMPTY, REVELATION_TYPE }

final revelationTypeValues = EnumValues(
    {"مكية": RevelationType.EMPTY, "مدنية": RevelationType.REVELATION_TYPE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
