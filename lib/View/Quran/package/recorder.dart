import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class RecordingWidget extends StatefulWidget {
  final Function(String filePath) onRecordingComplete;

  const RecordingWidget({Key? key, required this.onRecordingComplete})
      : super(key: key);

  @override
  _RecordingWidgetState createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      var storagePermission = await Permission.storage.status;
      if (!storagePermission.isGranted) {
        storagePermission = await Permission.storage.request();
      }

      if (storagePermission.isGranted) {
        Directory? externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          String path = '${externalDir.path}/recording.aac';
          await _recorder.startRecorder(toFile: path);
          setState(() {
            _isRecording = true;
            _filePath = path;
          });
        }
      } else {
        print("Storage permission not granted");
      }
    } else {
      print("Microphone permission not granted");
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_filePath != null) {
      widget.onRecordingComplete(_filePath!);
      await sendAudioFile(_filePath!, 1); // هنا اضفنا رقم السورة كمثال
    }
  }

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

        // عرض النتيجة في BottomSheet
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

  // دالة لعرض البيانات في BottomSheet
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
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(
            icon:
                Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.red),
            iconSize: 50,
            onPressed: _isRecording ? _stopRecording : _startRecording,
          ),
          Text(
            _isRecording ? 'جاري التسجيل...' : 'اضغط للتسجيل',
            style: TextStyle(fontSize: 16),
          ),
          if (_isUploading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري رفع الملف...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
