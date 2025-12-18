import 'package:equatable/equatable.dart';

enum FavoriteStatus { initial, loading, loaded, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final Set<String> favoriteVerses;
  final String? errorMessage;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favoriteVerses = const {},
    this.errorMessage,
  });

  FavoriteState copyWith({
    FavoriteStatus? status,
    Set<String>? favoriteVerses,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favoriteVerses: favoriteVerses ?? this.favoriteVerses,
      errorMessage: errorMessage,
    );
  }

  bool isFavorite(String verseKey) => favoriteVerses.contains(verseKey);

  @override
  List<Object?> get props => [status, favoriteVerses, errorMessage];
}
