import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _bookmarksKey = 'bookmarks';
  static const _favoritesKey = 'favorites';
  static const _lastReadSurahKey = 'lastReadSurah';
  static const _lastReadPageKey = 'lastReadPage';
  static const _lastReadVerseKey = 'lastReadVerse';

  // Bookmark methods
  static Future<void> addBookmark(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(verseKey)) {
      bookmarks.add(verseKey);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  static Future<void> removeBookmark(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(verseKey);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  static Future<List<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  // Favorite methods
  static Future<void> addFavorite(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(verseKey)) {
      favorites.add(verseKey);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(verseKey);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Last read methods
  static Future<void> setLastReadSurah(int surah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadSurahKey, surah);
  }

  static Future<int?> getLastReadSurah() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastReadSurahKey);
  }

  static Future<void> setLastReadPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadPageKey, page);
  }

  static Future<int?> getLastReadPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastReadPageKey);
  }

  static Future<void> setLastReadVerse(int verse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadVerseKey, verse);
  }

  static Future<int?> getLastReadVerse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastReadVerseKey);
  }
}
