import 'package:equatable/equatable.dart';
import 'package:quran/quran.dart' as quran;

enum SurahStatus { initial, loaded }

class SurahState extends Equatable {
  final SurahStatus status;
  final List<String> allSurahNames;
  final List<String> filteredSurahNames;
  final String searchQuery;

  SurahState({
    this.status = SurahStatus.initial,
    List<String>? allSurahNames,
    List<String>? filteredSurahNames,
    this.searchQuery = '',
  })  : allSurahNames = allSurahNames ??
            List.generate(
              quran.totalSurahCount,
              (index) => quran.getSurahNameArabic(index + 1),
            ),
        filteredSurahNames = filteredSurahNames ?? allSurahNames ?? [];

  SurahState copyWith({
    SurahStatus? status,
    List<String>? allSurahNames,
    List<String>? filteredSurahNames,
    String? searchQuery,
  }) {
    return SurahState(
      status: status ?? this.status,
      allSurahNames: allSurahNames ?? this.allSurahNames,
      filteredSurahNames: filteredSurahNames ?? this.filteredSurahNames,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [status, allSurahNames, filteredSurahNames, searchQuery];
}
