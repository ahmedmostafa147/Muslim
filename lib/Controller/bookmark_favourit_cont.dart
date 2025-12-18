import 'package:get/get.dart';
import '../Core/services/shared_perferance.dart';

class BookmarkController extends GetxController {
  var bookmarkedVerses = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    final bookmarks = await StorageService.getBookmarks();
    bookmarkedVerses.addAll(bookmarks);
  }

  void toggleBookmark(String verseKey) {
    if (bookmarkedVerses.contains(verseKey)) {
      bookmarkedVerses.remove(verseKey);
      StorageService.removeBookmark(verseKey);
    } else {
      bookmarkedVerses.add(verseKey);
      StorageService.addBookmark(verseKey);
    }
  }

  bool isBookmarked(String verseKey) {
    return bookmarkedVerses.contains(verseKey);
  }

  List<String> getBookmarkedVerses() {
    return bookmarkedVerses.toList();
  }
}

class FavoriteController extends GetxController {
  var favoriteVerses = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favorites = await StorageService.getFavorites();
    favoriteVerses.addAll(favorites);
  }

  void toggleFavorite(String verseKey) {
    if (favoriteVerses.contains(verseKey)) {
      favoriteVerses.remove(verseKey);
      StorageService.removeFavorite(verseKey);
    } else {
      favoriteVerses.add(verseKey);
      StorageService.addFavorite(verseKey);
    }
  }

  bool isFavorite(String verseKey) {
    return favoriteVerses.contains(verseKey);
  }

  List<String> getFavoriteVerses() {
    return favoriteVerses.toList();
  }
}
