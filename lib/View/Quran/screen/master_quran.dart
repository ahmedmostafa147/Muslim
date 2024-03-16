import 'package:Muslim/View/Quran/widget/widget_package/favorite_list.dart';

import '../../../Models/bookmark_quran.dart';
import '../../../Models/favorite_quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;

import '../widget/widget_package/bookmark_list.dart';
import '../widget/widget_package/surah_name_p.dart';
import 'reader_screen.dart';

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({Key? key}) : super(key: key);

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage>
    with SingleTickerProviderStateMixin {
  final basmala = quran.basmala;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              enableFeedback: true,
              splashBorderRadius: BorderRadius.circular(10.r),
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              controller: _tabController,
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0XFFD4A331)
                  : Colors.teal,
              indicatorColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0XFFD4A331)
                  : Colors.teal,
              tabs: const [
                Tab(icon: Icon(Icons.phone_iphone_rounded), text: 'المصحف'),
                Tab(icon: Icon(Icons.headphones), text: 'إستماع'),
                Tab(icon: Icon(Icons.bookmark), text: 'المحفوظات'),
                Tab(icon: Icon(Icons.favorite), text: 'المفضلة'),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                const ListSurahNamePackage(),
                ReaderList(),
                BookmarkScreen(bookmarkManager: BookmarkManager()),
                FavoriteScreen(favoriteManager: FavoriteManager()),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
