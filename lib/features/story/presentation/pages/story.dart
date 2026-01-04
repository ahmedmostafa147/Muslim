import 'package:muslim/core/constants/images.dart';

import 'story_details.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryHome extends StatelessWidget {
  const StoryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listData = [
      {
        'image': Assets.imagesRadio,
        'text': 'قصص الأنبياء',
        'filePath': 'assets/database/قصص الأنبياء.json',
      },
      {
        'image': Assets.imagesRadio,
        'text': 'قصص الحيوان',
        'filePath': 'assets/database/قصص الحيوان.json',
      },
      {
        'image': Assets.imagesRadio,
        'text': ' قصص الصحابة',
        'filePath': 'assets/database/قصص الصحابة.json',
      },
      {
        'image': Assets.imagesRadio,
        'text': 'قصص الصحابيات',
        'filePath': 'assets/database/قصص الصحابيات.json',
      },
      {
        'image': Assets.imagesRadio,
        'text': 'قصص القرآن',
        'filePath': 'assets/database/قصص القرآن.json',
      },
      {
        'image': Assets.imagesRadio,
        'text': 'معجزات الأنبياء',
        'filePath': 'assets/database/معجزات الأنبياء.json',
      },
       {
        'image': Assets.imagesRadio,
        'text': 'أسماء زوجات الرسل والأنبياء',
        'filePath': 'assets/database/أسماء زوجات الرسل والأنبياء.json',
      }

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
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Text(categoryTitle)),
                onTap: () => Get.to(
                      StoryDetails(
                        filePath: filePath,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
