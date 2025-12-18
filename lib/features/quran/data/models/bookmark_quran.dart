import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final int surahIndex;
  final int verseNumber;
  final String surahName;
  final String verseText;
  final int surahVerseCount;

  BookmarkItem({
    required this.surahIndex,
    required this.verseNumber,
    required this.surahName,
    required this.verseText,
    required this.surahVerseCount,
  });
}

class BookmarkManager {
  final String _key = 'bookmarks';

  Future<List<BookmarkItem>> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkStrings = prefs.getStringList(_key);
    if (bookmarkStrings == null) {
      return [];
    }

    return bookmarkStrings.map((bookmarkString) {
      List<String> parts = bookmarkString.split(',');
      return BookmarkItem(
        surahIndex: int.parse(parts[0]),
        verseNumber: int.parse(parts[1]),
        surahName: parts[2],
        verseText: parts[3],
        surahVerseCount: int.parse(parts[4]),
      );
    }).toList();
  }

  Future<void> addBookmark(BookmarkItem bookmarkItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BookmarkItem> bookmarks = await getBookmarks();
    bookmarks.add(bookmarkItem);
    List<String> bookmarkStrings = bookmarks
        .map((bookmark) =>
            '${bookmark.surahIndex},${bookmark.verseNumber},${bookmark.surahName},${bookmark.verseText},${bookmark.surahVerseCount}')
        .toList();
    prefs.setStringList(_key, bookmarkStrings);
  }

  Future<void> removeBookmark(BookmarkItem bookmarkItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BookmarkItem> bookmarks = await getBookmarks();
    bookmarks.removeWhere((item) =>
        item.surahIndex == bookmarkItem.surahIndex &&
        item.verseNumber == bookmarkItem.verseNumber);
    List<String> bookmarkStrings = bookmarks
        .map((bookmark) =>
            '${bookmark.surahIndex},${bookmark.verseNumber},${bookmark.surahName},${bookmark.verseText},${bookmark.surahVerseCount}')
        .toList();
    prefs.setStringList(_key, bookmarkStrings);
  }

  Future<bool> isBookmark(BookmarkItem bookmarkItem) async {
    List<BookmarkItem> bookmarks = await getBookmarks();
    return bookmarks.any((item) =>
        item.surahIndex == bookmarkItem.surahIndex &&
        item.verseNumber == bookmarkItem.verseNumber);
  }
}
