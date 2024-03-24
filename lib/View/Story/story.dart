import 'story_details.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Core/constant/images.dart';

class StoryHome extends StatelessWidget {
  const StoryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listData = [
      {
        'image': Assets.imagesHood,
        'text': 'قصص الأنبياء',
        'filePath': 'assets/database/قصص الأنبياء.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'قصص الحيوان',
        'filePath': 'assets/database/قصص الحيوان.json',
      },
      {
        'image': Assets.imagesHood,
        'text': ' قصص الصحابة',
        'filePath': 'assets/database/قصص الصحابة.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'قصص الصحابيات',
        'filePath': 'assets/database/قصص الصحابيات.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'قصص القرآن',
        'filePath': 'assets/database/قصص القرآن.json',
      },
      {
        'image': Assets.imagesHood,
        'text': 'معجزات الأنبياء',
        'filePath': 'assets/database/معجزات الأنبياء.json',
      },
       {
        'image': Assets.imagesHood,
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
                        color: Colors.teal,
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
