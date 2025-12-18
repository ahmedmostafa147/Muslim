import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:quran/quran.dart' as quran;

import 'surah_state.dart';

@injectable
class SurahCubit extends Cubit<SurahState> {
  SurahCubit() : super(SurahState()) {
    _init();
  }

  void _init() {
    final allNames = List.generate(
      quran.totalSurahCount,
      (index) => quran.getSurahNameArabic(index + 1),
    );
    emit(state.copyWith(
      status: SurahStatus.loaded,
      allSurahNames: allNames,
      filteredSurahNames: allNames,
    ));
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(
        filteredSurahNames: state.allSurahNames,
        searchQuery: '',
      ));
    } else {
      final filtered =
          state.allSurahNames.where((item) => item.contains(query)).toList();
      emit(state.copyWith(
        filteredSurahNames: filtered,
        searchQuery: query,
      ));
    }
  }

  void clearSearch() {
    emit(state.copyWith(
      filteredSurahNames: state.allSurahNames,
      searchQuery: '',
    ));
  }
}
