import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Pray {
  final String text;

  Pray({
    required this.text,
  });

  factory Pray.fromJson(Map<String, dynamic> json) {
    return Pray(
      text: json['text'],
    );
  }
}

class PrayController extends GetxController {
  RxList<Pray> prays = <Pray>[].obs;

  Future<void> fetchPray(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      List<dynamic> jsonList = jsonDecode(jsonString);
      prays.assignAll(jsonList.map((json) => Pray.fromJson(json)).toList());
    } catch (e) {
      print('Error fetching pray: $e');
    }
  }
}
