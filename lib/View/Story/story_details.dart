import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/story_load_data.dart';
import 'widget/story_item.dart';

class StoryDetails extends StatelessWidget {
  final String filePath;

  const StoryDetails({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.put<StoryController>(
      StoryController(),
    );
    storyController.fetchStory(filePath);
    return Scaffold(
      appBar: AppBar(
        title: const Text('قصص اسلامية'),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(10.0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: storyController.stories.length,
          itemBuilder: (context, index) {
            Story story = storyController.stories[index];
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
                    child: Text(story.number)),
                onTap: () => Get.to(
                      StroyItem(
                        number: story.number,
                        label: story.label,
                      ),
                    ));
          },
        ),
      ),
    );
  }
}
