import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/Models/api_reciters.dart';
import 'package:muslim/View/Reader/list_surah.dart';

class MoshafListScreen extends StatelessWidget {
  final Reciter reciter;

  const MoshafListScreen({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciter.name ?? ''),
      ),
      body: ListView.builder(
        itemCount: reciter.moshaf?.length ?? 0,
        itemBuilder: (context, index) {
          final moshaf = reciter.moshaf![index];
          return ListTile(
            title: Text(moshaf.name ?? ''),
            onTap: () {
              // Navigate to SurahListScreen or directly play
              Get.to(() => SurahListScreen(moshaf: moshaf, reciter: reciter));
            },
          );
        },
      ),
    );
  }
}
