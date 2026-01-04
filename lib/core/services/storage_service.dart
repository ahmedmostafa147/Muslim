import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  // Int
  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Double
  Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // Bool
  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // Remove
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return await prefs.clear();
  }

  // ============ Last Read Methods ============
  
  static const String _lastReadSurahKey = 'last_read_surah';
  static const String _lastReadSurahIndexKey = 'last_read_surah_index';
  static const String _lastReadVerseKey = 'last_read_verse';
  static const String _lastReadPageKey = 'last_read_page';
  static const String _lastReadModeKey = 'last_read_mode';
  static const String _bookmarksKey = 'bookmarks';
  static const String _favoritesKey = 'favorites';

  static Future<String?> getLastReadSurah() async {
    return prefs.getString(_lastReadSurahKey);
  }

  static Future<void> setLastReadSurah(String surah) async {
    await prefs.setString(_lastReadSurahKey, surah);
  }

  static Future<int?> getLastReadSurahIndex() async {
    return prefs.getInt(_lastReadSurahIndexKey);
  }

  static Future<void> setLastReadSurahIndex(int index) async {
    await prefs.setInt(_lastReadSurahIndexKey, index);
  }

  static Future<int?> getLastReadVerse() async {
    return prefs.getInt(_lastReadVerseKey);
  }

  static Future<void> setLastReadVerse(int verse) async {
    await prefs.setInt(_lastReadVerseKey, verse);
  }

  static Future<int?> getLastReadPage() async {
    return prefs.getInt(_lastReadPageKey);
  }

  static Future<void> setLastReadPage(int page) async {
    await prefs.setInt(_lastReadPageKey, page);
  }

  static Future<String?> getLastReadMode() async {
    return prefs.getString(_lastReadModeKey);
  }

  static Future<void> setLastReadMode(String mode) async {
    await prefs.setString(_lastReadModeKey, mode);
  }

  // ============ Bookmarks Methods ============

  static Future<List<String>> getBookmarks() async {
    final String? bookmarksJson = prefs.getString(_bookmarksKey);
    if (bookmarksJson == null) return [];
    return List<String>.from(jsonDecode(bookmarksJson));
  }

  static Future<void> addBookmark(String verseKey) async {
    final bookmarks = await getBookmarks();
    if (!bookmarks.contains(verseKey)) {
      bookmarks.add(verseKey);
      await prefs.setString(_bookmarksKey, jsonEncode(bookmarks));
    }
  }

  static Future<void> removeBookmark(String verseKey) async {
    final bookmarks = await getBookmarks();
    bookmarks.remove(verseKey);
    await prefs.setString(_bookmarksKey, jsonEncode(bookmarks));
  }

  // ============ Favorites Methods ============

  static Future<List<String>> getFavorites() async {
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];
    return List<String>.from(jsonDecode(favoritesJson));
  }

  static Future<void> addFavorite(String verseKey) async {
    final favorites = await getFavorites();
    if (!favorites.contains(verseKey)) {
      favorites.add(verseKey);
      await prefs.setString(_favoritesKey, jsonEncode(favorites));
    }
  }

  static Future<void> removeFavorite(String verseKey) async {
    final favorites = await getFavorites();
    favorites.remove(verseKey);
    await prefs.setString(_favoritesKey, jsonEncode(favorites));
  }
}
