import 'package:equatable/equatable.dart';

enum LastReadStatus { initial, loaded }

class LastReadState extends Equatable {
  final LastReadStatus status;
  final String surahName;
  final int surahNumber;
  final int verseNumber;
  final int pageNumber;
  final String lastReadMode;
  final bool isVisible;

  const LastReadState({
    this.status = LastReadStatus.initial,
    this.surahName = '',
    this.surahNumber = 0,
    this.verseNumber = 0,
    this.pageNumber = 0,
    this.lastReadMode = '',
    this.isVisible = false,
  });

  LastReadState copyWith({
    LastReadStatus? status,
    String? surahName,
    int? surahNumber,
    int? verseNumber,
    int? pageNumber,
    String? lastReadMode,
    bool? isVisible,
  }) {
    return LastReadState(
      status: status ?? this.status,
      surahName: surahName ?? this.surahName,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      lastReadMode: lastReadMode ?? this.lastReadMode,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [
        status,
        surahName,
        surahNumber,
        verseNumber,
        pageNumber,
        lastReadMode,
        isVisible,
      ];
}
