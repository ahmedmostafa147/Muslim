import 'ramadan_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Muslim/Core/constant/Images.dart';
class RamadanHome extends StatelessWidget {
  const RamadanHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listData = [
      {
        'image': Assets.imagesHood,
        'text': 'أحكام وفتاوى رمضان المبارك',
        'filePath': 'assets/database/أحكام وفتاوى رمضان المبارك.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'أدعية لشهر رمضان المبارك',
        'filePath': 'assets/database/أدعية لشهر رمضان المبارك.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'صحتك في شهر رمضان المبارك',
        'filePath': 'assets/database/صحتك في شهر رمضان المبارك.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'طرق ختم القران الكريم في رمضان',
        'filePath': 'assets/database/طرق ختم القران الكريم في رمضان.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'نصائح لشهر رمضان المبارك',
        'filePath': 'assets/database/نصائح لشهر رمضان المبارك.json',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('رمضان'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context, index) {
            String categoryTitle = listData[index]['text'];
            String filePath = listData[index]['filePath'];
            return ListTile(
                title: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.teal,
                        width: 1,
                      ),
                    ),
                    child: Text(categoryTitle)),
                onTap: () => Get.to(
                      RamadanDetails(
                        filePath: filePath,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
