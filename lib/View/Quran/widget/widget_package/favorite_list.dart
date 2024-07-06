import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:muslim/Core/constant/themes.dart';
import '../../../../Models/favorite_quran.dart';

class FavoriteScreen extends StatefulWidget {
  final FavoriteManager favoriteManager;

  const FavoriteScreen({Key? key, required this.favoriteManager})
      : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteItem> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.favoriteManager.getFavorites(),
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

          _favorites = snapshot.data as List<FavoriteItem>;

          if (_favorites.isEmpty) {
            return const Center(
              child: Text('لم تقم بإضافة أي عنصر إلى المفضلة'),
            );
          }

          return ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              FavoriteItem favorite = _favorites[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${favorite.surahName} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color:Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(favorite.verseText,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: TextFontType.quranFont)),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await widget.favoriteManager.removeFavorite(favorite);
                    setState(() {
                      _favorites.remove(favorite);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
