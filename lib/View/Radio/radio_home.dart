import 'package:flutter/material.dart';

import '../../Models/radio_load_data.dart';
import 'radio_title.dart';

class RadioHomeScreen extends StatefulWidget {
  const RadioHomeScreen({Key? key}) : super(key: key);

  @override
  State<RadioHomeScreen> createState() => _RadioHomeScreenState();
}

class _RadioHomeScreenState extends State<RadioHomeScreen> {
  late RadioJsonLoader jsonLoader;

  @override
  void initState() {
    super.initState();
    jsonLoader = RadioJsonLoader();
    jsonLoader.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الراديو'),
      ),
      body: FutureBuilder(
        future: jsonLoader.loadData(),
        builder: (context, snapshot) {
          return TitleListRadio(radioStations: jsonLoader.radioStations);
        }
      ),
    );
  }
}