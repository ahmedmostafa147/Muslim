import '../../../../Models/bookmark_quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:Muslim/Core/constant/text_style.dart';

import '../../screen/surah_screen_package.dart';


class BookmarkScreen extends StatefulWidget {
  final BookmarkManager bookmarkManager;

  const BookmarkScreen({Key? key, required this.bookmarkManager})
      : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<BookmarkItem> _bookmarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.bookmarkManager.getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          _bookmarks = snapshot.data as List<BookmarkItem>;

          if (_bookmarks.isEmpty) {
            return const Center(
              child: Text('لم تقم بإضافة أي عنصر إلى المحفوظات'),
            );
          }

          return ListView.builder(
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) {
              BookmarkItem bookmark = _bookmarks[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.sp),
              
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookmark.surahName,
                        style:  TextStyle(fontSize: 20.sp,fontFamily: TextFontStyle.quranFont,fontWeight: FontWeight.bold,color:Theme.of(context).brightness==Brightness.dark?Colors.amber:Colors.teal, ),
                        
                      ),
                       SizedBox(height: 10.h),
                      
                      Text(' ${bookmark.verseText}',
                          style:  TextStyle(fontSize: 15.sp,fontFamily: TextFontStyle.quranFont)),
                    ],
                  ),
                  onTap: () {
                    Get.to(
                      SurahPage(
                        surahIndex: bookmark.surahIndex,
                        surahVerseCount: bookmark.surahVerseCount,
                        surahName: bookmark.surahName,
                      ),
                    );
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      await widget.bookmarkManager.removeBookmark(bookmark);
                      setState(() {
                        _bookmarks.remove(bookmark);
                      });
                    },
                    icon: const Icon(Icons.bookmark_remove),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
