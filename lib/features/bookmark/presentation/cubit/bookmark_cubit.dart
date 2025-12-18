import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../Core/services/shared_perferance.dart';
import 'bookmark_state.dart';

@injectable
class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(const BookmarkState()) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      final bookmarks = await StorageService.getBookmarks();
      emit(state.copyWith(
        status: BookmarkStatus.loaded,
        bookmarkedVerses: bookmarks.toSet(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to load bookmarks',
      ));
    }
  }

  Future<void> toggleBookmark(String verseKey) async {
    final currentBookmarks = Set<String>.from(state.bookmarkedVerses);

    if (currentBookmarks.contains(verseKey)) {
      currentBookmarks.remove(verseKey);
      await StorageService.removeBookmark(verseKey);
    } else {
      currentBookmarks.add(verseKey);
      await StorageService.addBookmark(verseKey);
    }

    emit(state.copyWith(bookmarkedVerses: currentBookmarks));
  }

  List<String> getBookmarkedVerses() {
    return state.bookmarkedVerses.toList();
  }
}
