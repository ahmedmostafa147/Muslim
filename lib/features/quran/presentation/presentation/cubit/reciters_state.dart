import 'package:equatable/equatable.dart';
import 'package:muslim/Models/api_reciters.dart';

enum RecitersStatus { initial, loading, loaded, error }

class RecitersState extends Equatable {
  final RecitersStatus status;
  final List<Reciter> recitersList;
  final List<Reciter> filteredRecitersList;
  final String searchQuery;
  final String? errorMessage;

  const RecitersState({
    this.status = RecitersStatus.initial,
    this.recitersList = const [],
    this.filteredRecitersList = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  RecitersState copyWith({
    RecitersStatus? status,
    List<Reciter>? recitersList,
    List<Reciter>? filteredRecitersList,
    String? searchQuery,
    String? errorMessage,
  }) {
    return RecitersState(
      status: status ?? this.status,
      recitersList: recitersList ?? this.recitersList,
      filteredRecitersList: filteredRecitersList ?? this.filteredRecitersList,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recitersList,
        filteredRecitersList,
        searchQuery,
        errorMessage,
      ];
}
