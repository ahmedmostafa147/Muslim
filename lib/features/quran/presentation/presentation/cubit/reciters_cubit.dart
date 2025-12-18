import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/api_reciters.dart';
import 'reciters_state.dart';

@injectable
class RecitersCubit extends Cubit<RecitersState> {
  final SharedPreferences _prefs;

  RecitersCubit(this._prefs) : super(const RecitersState()) {
    _loadReciters();
  }

  Future<void> _loadReciters() async {
    emit(state.copyWith(status: RecitersStatus.loading));

    try {
      // Try to load from cache first
      final cachedData = _prefs.getString('reciters_cache');
      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        final reciters = jsonData.map((e) => Reciter.fromJson(e)).toList();
        emit(state.copyWith(
          status: RecitersStatus.loaded,
          recitersList: reciters,
          filteredRecitersList: reciters,
        ));
        return;
      }

      // Fetch from API
      final response = await http.get(
        Uri.parse('https://mp3quran.net/api/v3/reciters?language=ar'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recitersJson = data['reciters'];
        final reciters = recitersJson.map((e) => Reciter.fromJson(e)).toList();

        // Cache the data
        await _prefs.setString('reciters_cache', json.encode(recitersJson));

        emit(state.copyWith(
          status: RecitersStatus.loaded,
          recitersList: reciters,
          filteredRecitersList: reciters,
        ));
      } else {
        emit(state.copyWith(
          status: RecitersStatus.error,
          errorMessage: 'فشل تحميل القراء',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RecitersStatus.error,
        errorMessage: 'حدث خطأ: $e',
      ));
    }
  }

  void filterReciters(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(
        filteredRecitersList: state.recitersList,
        searchQuery: query,
      ));
    } else {
      final filtered = state.recitersList
          .where((reciter) =>
              reciter.name?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
      emit(state.copyWith(
        filteredRecitersList: filtered,
        searchQuery: query,
      ));
    }
  }
}
