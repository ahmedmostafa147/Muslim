import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItem {
  final int surahIndex;
  final int verseNumber;
  final String surahName;
  final String verseText;
  final int surahVerseCount;

  FavoriteItem({
    required this.surahIndex,
    required this.verseNumber,
    required this.surahName,
    required this.verseText,
    required this.surahVerseCount,
  });
}

class FavoriteManager {
  final String _key = 'favorites';

  Future<List<FavoriteItem>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteStrings = prefs.getStringList(_key);
    if (favoriteStrings == null) {
      return [];
    }

    return favoriteStrings.map((favoriteString) {
      List<String> parts = favoriteString.split(',');
      return FavoriteItem(
        surahIndex: int.parse(parts[0]),
        verseNumber: int.parse(parts[1]),
        surahName: parts[2],
        verseText: parts[3],
        surahVerseCount: int.parse(parts[4]),
      );
    }).toList();
  }

  Future<void> addFavorite(FavoriteItem favoriteItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<FavoriteItem> favorites = await getFavorites();
    favorites.add(favoriteItem);
    List<String> favoriteStrings = favorites
        .map((favorite) =>
            '${favorite.surahIndex},${favorite.verseNumber},${favorite.surahName},${favorite.verseText},${favorite.surahVerseCount}')
        .toList();
    prefs.setStringList(_key, favoriteStrings);
  }

  Future<void> removeFavorite(FavoriteItem favoriteItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<FavoriteItem> favorites = await getFavorites();
    favorites.removeWhere(
      (item) =>
          item.surahIndex == favoriteItem.surahIndex &&
          item.verseNumber == favoriteItem.verseNumber,
    );
    List<String> favoriteStrings = favorites
        .map((favorite) =>
            '${favorite.surahIndex},${favorite.verseNumber},${favorite.surahName},${favorite.verseText},${favorite.surahVerseCount}')
        .toList();
    prefs.setStringList(_key, favoriteStrings);
  }

  // New method to check if a verse is in favorites
  Future<bool> isFavorite(FavoriteItem favoriteItem) async {
    List<FavoriteItem> favorites = await getFavorites();
    return favorites.any(
      (item) =>
          item.surahIndex == favoriteItem.surahIndex &&
          item.verseNumber == favoriteItem.verseNumber,
    );
  }
}
