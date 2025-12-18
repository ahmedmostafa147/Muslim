import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class Ramadan {
  final String number;
  final String text;
  final String label;

  Ramadan({
    required this.number,
    required this.text,
    required this.label,
  });

  factory Ramadan.fromJson(Map<String, dynamic> json) {
    return Ramadan(
        number: json['number'], text: json['text'], label: json['label']);
  }
}

class RamadanController extends GetxController {
  RxList<Ramadan> ramadans = <Ramadan>[].obs;

  Future<void> fetchRamadan(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      List<dynamic> jsonList = jsonDecode(jsonString);
      ramadans
          .assignAll(jsonList.map((json) => Ramadan.fromJson(json)).toList());
    } catch (e) {
      print('Error fetching Ramadan: $e');
    }
  }
}
