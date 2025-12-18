import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class Story {
  final String number;
  final String text;
  final String label;

  Story({
    required this.number,
    required this.text,
    required this.label,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        number: json['number'], text: json['text'], label: json['label']);
  }
}

class StoryController extends GetxController {
  RxList<Story> stories = <Story>[].obs;

  Future<void> fetchStory(String filePath) async {
    try {
      String jsonString = await rootBundle.loadString(filePath);
      List<dynamic> jsonList = jsonDecode(jsonString);
      stories
          .assignAll(jsonList.map((json) => Story.fromJson(json)).toList());
    } catch (e) {
     
    }
  }
}
