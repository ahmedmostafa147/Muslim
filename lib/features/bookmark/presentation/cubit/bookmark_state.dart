import 'package:equatable/equatable.dart';

enum BookmarkStatus { initial, loading, loaded, error }

class BookmarkState extends Equatable {
  final BookmarkStatus status;
  final Set<String> bookmarkedVerses;
  final String? errorMessage;

  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarkedVerses = const {},
    this.errorMessage,
  });

  BookmarkState copyWith({
    BookmarkStatus? status,
    Set<String>? bookmarkedVerses,
    String? errorMessage,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarkedVerses: bookmarkedVerses ?? this.bookmarkedVerses,
      errorMessage: errorMessage,
    );
  }

  bool isBookmarked(String verseKey) => bookmarkedVerses.contains(verseKey);

  @override
  List<Object?> get props => [status, bookmarkedVerses, errorMessage];
}
