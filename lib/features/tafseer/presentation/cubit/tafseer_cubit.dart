import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'tafseer_state.dart';

@injectable
class TafseerCubit extends Cubit<TafseerState> {
  TafseerCubit() : super(const TafseerState()) {
    _loadTafseer();
  }

  Future<void> _loadTafseer() async {
    emit(state.copyWith(status: TafseerStatus.loading));
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/tafseer.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      final surahs = jsonData.map((surahJson) {
        final ayahs = (surahJson['ayahs'] as List).map((ayahJson) {
          return TafseerAyah(
            number: ayahJson['number'] ?? 0,
            numberInSurah: ayahJson['numberInSurah'] ?? 0,
            page: ayahJson['page'] ?? 0,
            juz: ayahJson['juz'] ?? 0,
            text: ayahJson['text'] ?? '',
            tafseer: ayahJson['tafseer'] ?? '',
          );
        }).toList();

        return TafseerSurah(
          number: surahJson['number'] ?? 0,
          name: surahJson['name'] ?? '',
          ayahs: ayahs,
        );
      }).toList();

      emit(state.copyWith(
        status: TafseerStatus.loaded,
        surahs: surahs,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TafseerStatus.error,
        errorMessage: 'فشل تحميل التفسير',
      ));
    }
  }

  TafseerSurah? getSurahByNumber(int surahNumber) {
    return state.getSurahByNumber(surahNumber);
  }

  TafseerSurah? getSurahByPage(int pageNumber) {
    return state.getSurahByPage(pageNumber);
  }

  List<TafseerAyah>? getAyahsByPage(int pageNumber) {
    return state.getAyahsByPage(pageNumber);
  }
}
