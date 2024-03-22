import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Models/radio_load_data.dart';
import 'radio_play.dart';
import 'widget/radio_list.dart';

class RadioNameAndUrl extends StatelessWidget {
  final String radioTitle;
  final List<RadioItemNew>? radioItems;
  final Widget radioName;

  const RadioNameAndUrl(
      {Key? key,
      required this.radioItems,
      required this.radioName,
      required this.radioTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: radioName,
      ),
      body: ListView.builder(
        itemCount: radioItems?.length ?? 0,
        itemBuilder: (context, index) {
          final item = radioItems![index];
          final name = item.name;
          final url = item.url;

          return RadioListUi(
            title: name!,
            onTap: () {
              Get.to(() => PlayRadio(
                  radioTitle: radioTitle,
                  radioName: name,
                  radioUrl: url.toString()));
            },
          );
        },
      ),
    );
  }
}
