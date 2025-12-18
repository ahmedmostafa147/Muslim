import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AudioUploader extends StatefulWidget {
  const AudioUploader({super.key});

  @override
  _AudioUploaderState createState() => _AudioUploaderState();
}

class _AudioUploaderState extends State<AudioUploader> {
  bool _isUploading = false;

  Future<void> sendAudioFile(String filePath, int surahNumber) async {
    setState(() {
      _isUploading = true;
    });

    final uri = Uri.parse("http://192.168.1.2:8000/analyze/");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath))
      ..fields['surah_number'] = surahNumber.toString();

    try {
      var response = await request.send();

      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        showResultBottomSheet(jsonResponse);
      } else {
        print("Failed to upload audio, status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error: $e");
    }
  }

  void showResultBottomSheet(Map<String, dynamic> resultData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "نتيجة التحليل",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildResultRow("النص المحول:", resultData["transcribed_text"]),
              buildResultRow("النص الصحيح:", resultData["correct_text"]),
              buildResultRow("نسبة التشابه:", "${resultData["similarity"]}%"),
              buildResultRow("رقم الآية:", resultData["ayah_number"]),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("إغلاق"),
              ),
            ],
          ),
        );
      },
    );
  }

  // دالة لبناء صفوف النتائج
  Widget buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Audio")),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  // استدعاء الدالة مع المثال
                  await sendAudioFile('path/to/your/file.mp3', 1);
                },
                child: Text("Upload Audio"),
              ),
      ),
    );
  }
}
