import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/reciters_controller.dart';
import '../../Models/api_reciters.dart';
import 'list_surah.dart';
import 'type_mushaf.dart';
import '../../widgets/loading_widget.dart';

class RecitersListScreen extends StatelessWidget {
  final RecitersController controller = Get.put(RecitersController());

  RecitersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القراء'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.filterReciters(value);
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن القارئ',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: LoadingWidget());
              } else {
                return ListView.builder(
                  itemCount: controller.filteredRecitersList.length,
                  itemBuilder: (context, index) {
                    return ReaderCustomTile(
                      reciter: controller.filteredRecitersList[index],
                      onTap: () {
                        final reciter = controller.filteredRecitersList[index];
                        if (reciter.moshaf != null &&
                            reciter.moshaf!.length == 1) {
                          Get.to(() => SurahListScreen(
                              reciter: reciter, moshaf: reciter.moshaf![0]));
                        } else {
                          Get.to(() => MoshafListScreen(reciter: reciter));
                        }
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class ReaderCustomTile extends StatelessWidget {
  final Reciter reciter;
  final VoidCallback onTap;

  const ReaderCustomTile({super.key, required this.reciter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            reciter.name ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
