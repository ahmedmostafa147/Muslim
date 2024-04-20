import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:muslim/widgets/loading_widget.dart';

import '../../../Models/reader_load_data.dart';
import '../widget/widget_Api/audio_surah_screen.dart';
import '../widget/widget_Api/reader_custom_tile.dart';

class ReaderList extends StatelessWidget {
  ReaderList({Key? key}) : super(key: key);

  late Future<List<Reader>> _readerListFuture;

  final ReaderLoadData readerLoadData = ReaderLoadData();

  @override
  Widget build(BuildContext context) {
    _readerListFuture = readerLoadData.getReaderList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة القراء'),
      ),
      body: FutureBuilder<List<Reader>>(
        future: _readerListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ أثناء تحميل البيانات: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ReaderCustomTile(
                  reader: snapshot.data![index],
                  onTap: () {
                    Get.to(
                      () => AudioSurahScreen(
                        reader: snapshot.data![index],
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('لا توجد بيانات متاحة'),
            );
          }
        },
      ),
    );
  }
}
