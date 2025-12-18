import 'package:equatable/equatable.dart';

enum TafseerStatus { initial, loading, loaded, error }

class TafseerState extends Equatable {
  final TafseerStatus status;
  final List<TafseerSurah> surahs;
  final String? errorMessage;

  const TafseerState({
    this.status = TafseerStatus.initial,
    this.surahs = const [],
    this.errorMessage,
  });

  TafseerSurah? getSurahByNumber(int surahNumber) {
    try {
      return surahs.firstWhere((s) => s.number == surahNumber);
    } catch (_) {
      return null;
    }
  }

  TafseerSurah? getSurahByPage(int pageNumber) {
    try {
      return surahs.firstWhere(
        (s) => s.ayahs.any((a) => a.page == pageNumber),
      );
    } catch (_) {
      return null;
    }
  }

  List<TafseerAyah>? getAyahsByPage(int pageNumber) {
    final surah = getSurahByPage(pageNumber);
    return surah?.ayahs.where((a) => a.page == pageNumber).toList();
  }

  TafseerState copyWith({
    TafseerStatus? status,
    List<TafseerSurah>? surahs,
    String? errorMessage,
  }) {
    return TafseerState(
      status: status ?? this.status,
      surahs: surahs ?? this.surahs,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, surahs, errorMessage];
}

class TafseerSurah {
  final int number;
  final String name;
  final List<TafseerAyah> ayahs;

  TafseerSurah({
    required this.number,
    required this.name,
    required this.ayahs,
  });
}

class TafseerAyah {
  final int number;
  final int numberInSurah;
  final int page;
  final int juz;
  final String text;
  final String tafseer;

  TafseerAyah({
    required this.number,
    required this.numberInSurah,
    required this.page,
    required this.juz,
    required this.text,
    required this.tafseer,
  });
}
