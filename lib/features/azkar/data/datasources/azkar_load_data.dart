// dhikr_controller.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

// Define the Dhikr model
class Dhikr {
  final int number;
  final String hint;
  final String text;
  final bool check;

  Dhikr({
    required this.number,
    required this.hint,
    required this.text,
    required this.check,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      number: json['number'],
      hint: json['hint'],
      text: json['text'],
      check: json['check'] == 'true',
    );
  }
}

class DhikrController extends GetxController {
  RxList<Dhikr> dhikrs = <Dhikr>[].obs;

  Future<void> fetchDhikrs(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      List<dynamic> jsonList = jsonDecode(jsonString);
      dhikrs.assignAll(jsonList.map((json) => Dhikr.fromJson(json)).toList());
    } catch (e) {
      print('Error fetching dhikrs: $e');
    }
  }
}


