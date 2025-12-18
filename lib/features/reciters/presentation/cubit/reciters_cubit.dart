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
    fetchReciters();
  }

  Future<void> fetchReciters() async {
    emit(state.copyWith(status: RecitersStatus.loading));

    try {
      // Try to load from cache first
      final savedReciters = _prefs.getString('recitersList');
      if (savedReciters != null) {
        final jsonResponse = json.decode(savedReciters) as List;
        final reciters =
            jsonResponse.map((reciter) => Reciter.fromJson(reciter)).toList();
        _sortAndEmit(reciters);
        return;
      }

      // Fetch from API
      final response = await http.get(
        Uri.parse('https://mp3quran.net/api/v3/reciters'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body)['reciters'] as List;
        final reciters =
            jsonResponse.map((reciter) => Reciter.fromJson(reciter)).toList();

        // Cache the response
        await _prefs.setString('recitersList', json.encode(jsonResponse));

        _sortAndEmit(reciters);
      } else {
        emit(state.copyWith(
          status: RecitersStatus.error,
          errorMessage: 'Failed to load reciters',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RecitersStatus.error,
        errorMessage: 'Error loading reciters: ${e.toString()}',
      ));
    }
  }

  void _sortAndEmit(List<Reciter> reciters) {
    reciters.sort((a, b) => (a.letter ?? '').compareTo(b.letter ?? ''));
    emit(state.copyWith(
      status: RecitersStatus.loaded,
      recitersList: reciters,
      filteredRecitersList: reciters,
    ));
  }

  void filterReciters(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(
        filteredRecitersList: state.recitersList,
        searchQuery: '',
      ));
    } else {
      final filtered = state.recitersList.where((reciter) {
        final name = reciter.name?.toLowerCase() ?? '';
        final letter = reciter.letter?.toLowerCase() ?? '';
        final lowerQuery = query.toLowerCase();
        return name.contains(lowerQuery) || letter.contains(lowerQuery);
      }).toList();

      emit(state.copyWith(
        filteredRecitersList: filtered,
        searchQuery: query,
      ));
    }
  }

  void clearFilter() {
    emit(state.copyWith(
      filteredRecitersList: state.recitersList,
      searchQuery: '',
    ));
  }
}
