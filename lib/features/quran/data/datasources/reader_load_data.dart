import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Reader {
  int? id;
  String? name;
  String? arabicName;
  String? relativePath;
  String? fileFormats;

  Reader({
    this.id,
    this.name,
    this.arabicName,
    this.relativePath,
    this.fileFormats,
  });

  Reader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arabicName = json['arabic_name'];
    relativePath = json['relative_path'];
    fileFormats = json['file_formats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arabic_name'] = arabicName;
    data['relative_path'] = relativePath;
    data['file_formats'] = fileFormats;

    return data;
  }
}

class ReaderLoadData {
  Future<List<Reader>> getReaderList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const url = "https://quranicaudio.com/api/qaris";

    if (prefs.containsKey('readerList')) {
      // Return cached data if available
      final cachedData = prefs.getString('readerList');
      final List<dynamic> jsonResponse = jsonDecode(cachedData!);
      return jsonResponse.map((item) => Reader.fromJson(item)).toList();
    } else {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(res.body);
        List<Reader> readerList = [];

        for (var item in jsonResponse) {
          Reader reader = Reader.fromJson(item);
          if (reader.arabicName != null) {
            readerList.add(reader);
          }
        }

        // Cache data locally
        await prefs.setString('readerList', jsonEncode(jsonResponse));

        return readerList;
      } else {
        throw Exception('Failed to load Reader');
      }
    }
  }
}
