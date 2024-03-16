import '../../../../Models/bookmark_quran.dart';
import '../../../../Models/favorite_quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'audio_controler.dart';

class RowIconVerse extends StatefulWidget {
  const RowIconVerse({
    Key? key,
    required this.favoriteManager,
    required this.bookManger,
    required this.verseTextForSurah,
    required this.surahName,
    required this.surahNumber,
    required this.surahVerseCount,
    required this.verseNumber,
    required this.onTapFavorite,
    required this.onTapBookmark,
  }) : super(key: key);

  final FavoriteManager favoriteManager;
  final BookmarkManager bookManger;
  final String verseTextForSurah;
  final String surahName;
  final int surahNumber;
  final int verseNumber;
  final int surahVerseCount;
  final VoidCallback onTapFavorite;
  final VoidCallback onTapBookmark;

  @override
  _RowIconVerseState createState() => _RowIconVerseState();
}

class _RowIconVerseState extends State<RowIconVerse> {
  bool isFavorite = false;
  bool isBookmark = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
    checkBookmark();
  }

  void checkBookmark() async {
    bool bookmark = await widget.bookManger.isBookmark(
      BookmarkItem(
        surahIndex: widget.surahNumber,
        verseNumber: widget.verseNumber,
        surahName: widget.surahName,
        verseText: widget.verseTextForSurah,
        surahVerseCount: widget.surahVerseCount,
      ),
    );
    setState(() {
      isBookmark = bookmark;
    });
  }

  void checkFavorite() async {
    bool favorite = await widget.favoriteManager.isFavorite(
      FavoriteItem(
        surahIndex: widget.surahNumber,
        verseNumber: widget.verseNumber,
        surahName: widget.surahName,
        verseText: widget.verseTextForSurah,
        surahVerseCount: widget.surahVerseCount,
      ),
    );
    setState(() {
      isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(QuranicVersePlayer(
                surahNumber: widget.surahNumber,
                verseNumber: widget.verseNumber,
              ));
            },
            icon: const Icon(Icons.headphones_outlined),
          ),
          IconButton(
            onPressed: () {
              toggleBookManger();

              widget.onTapBookmark();
            },
            icon: Icon(
              isBookmark ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmark
                  ? Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal
                  : null,
            ),
          ),
          IconButton(
            onPressed: () {
              toggleFavorite();
              widget.onTapFavorite();
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.copy_rounded,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.verseTextForSurah));
              Get.snackbar(widget.surahName, 'تم نسخ الآية');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
            ),
            onPressed: () => _shareVerse(widget.verseTextForSurah),
          ),
        ],
      ),
    );
  }

  void _shareVerse(String verseText) {
    final String text = '${widget.surahName} - $verseText';
    const String subject = 'Quran';
    Share.share(text, subject: subject);
  }

  void toggleBookManger() {
    setState(() {
      isBookmark = !isBookmark;
    });

    if (isBookmark) {
      widget.bookManger.addBookmark(
        BookmarkItem(
          surahIndex: widget.surahNumber,
          verseNumber: widget.verseNumber,
          surahName: widget.surahName,
          verseText: widget.verseTextForSurah,
          surahVerseCount: widget.surahVerseCount,
        ),
      );
    } else {
      widget.bookManger.removeBookmark(
        BookmarkItem(
          surahIndex: widget.surahNumber,
          verseNumber: widget.verseNumber,
          surahName: widget.surahName,
          verseText: widget.verseTextForSurah,
          surahVerseCount: widget.surahVerseCount,
        ),
      );
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      widget.favoriteManager.addFavorite(
        FavoriteItem(
          surahIndex: widget.surahNumber,
          verseNumber: widget.verseNumber,
          surahName: widget.surahName,
          verseText: widget.verseTextForSurah,
          surahVerseCount: widget.surahVerseCount,
        ),
      );
    } else {
      widget.favoriteManager.removeFavorite(
        FavoriteItem(
          surahIndex: widget.surahNumber,
          verseNumber: widget.verseNumber,
          surahName: widget.surahName,
          verseText: widget.verseTextForSurah,
          surahVerseCount: widget.surahVerseCount,
        ),
      );
    }
  }
}
