import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../Core/services/shared_perferance.dart';
import 'favorite_state.dart';

@injectable
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    emit(state.copyWith(status: FavoriteStatus.loading));
    try {
      final favorites = await StorageService.getFavorites();
      emit(state.copyWith(
        status: FavoriteStatus.loaded,
        favoriteVerses: favorites.toSet(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: 'Failed to load favorites',
      ));
    }
  }

  Future<void> toggleFavorite(String verseKey) async {
    final currentFavorites = Set<String>.from(state.favoriteVerses);

    if (currentFavorites.contains(verseKey)) {
      currentFavorites.remove(verseKey);
      await StorageService.removeFavorite(verseKey);
    } else {
      currentFavorites.add(verseKey);
      await StorageService.addFavorite(verseKey);
    }

    emit(state.copyWith(favoriteVerses: currentFavorites));
  }

  List<String> getFavoriteVerses() {
    return state.favoriteVerses.toList();
  }
}
