class Reciter {
  int? id;
  String? name;
  String? letter;
  List<Moshaf>? moshaf;

  Reciter({this.id, this.name, this.letter, this.moshaf});

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'],
      name: json['name'],
      letter: json['letter'],
      moshaf: (json['moshaf'] as List?)?.map((i) => Moshaf.fromJson(i)).toList(),
    );
  }
}

class Moshaf {
  int? id;
  String? name;
  String? server;
  int? surahTotal;
  int? moshafType;
  String? surahList;

  Moshaf({this.id, this.name, this.server, this.surahTotal, this.moshafType, this.surahList});

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      surahTotal: json['surah_total'],
      moshafType: json['moshaf_type'],
      surahList: json['surah_list'],
    );
  }
}