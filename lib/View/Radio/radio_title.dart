import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/radio_load_data.dart';
import 'radio_name_url.dart';
import 'widget/radio_list.dart';

class TitleListRadio extends StatelessWidget {
  final List<RadioStationNew> radioStations;

  const TitleListRadio({super.key, required this.radioStations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: radioStations.length,
      itemBuilder: (context, index) {
        final station = radioStations[index];
        final title = station.title;

        return RadioListUi(
            title: title!,
            onTap: () {
              Get.to(() => RadioNameAndUrl(
                    radioTitle: station.title.toString(),
                    radioItems: station.radio,
                    radioName: Text(title),
                  ));
            });
      },
    );
  }
}
