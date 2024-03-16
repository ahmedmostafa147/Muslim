import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;

class RadioStationNew {
  String? title;
  List<RadioItemNew>? radio;

  RadioStationNew({
    required this.title,
    required this.radio,
  });
}

class RadioItemNew {
  String? name;
  String? url;

  RadioItemNew({
    required this.name,
    required this.url,
  });
}

class RadioJsonLoader {
  List<RadioStationNew> radioStations = [];

  Future<void> loadData() async {
    String data =
        await rootBundle.loadString('assets/database/radios_new.json');
    List<dynamic> jsonList = json.decode(data);
    radioStations = jsonList
        .map((jsonItem) => RadioStationNew(
              title: jsonItem['title'],
              radio: (jsonItem['radio'] as List<dynamic>?)
                  ?.map((radio) => RadioItemNew(
                        name: radio['name'],
                        url: radio['url'],
                      ))
                  .toList(),
            ))
        .toList();
  }
}


