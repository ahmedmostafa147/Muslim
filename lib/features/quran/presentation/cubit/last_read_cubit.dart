import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../Core/services/shared_perferance.dart';
import 'last_read_state.dart';

@injectable
class LastReadCubit extends Cubit<LastReadState> {
  LastReadCubit() : super(const LastReadState()) {
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final surahName = await StorageService.getLastReadSurah() ?? '';
    final surahNumber = await StorageService.getLastReadSurahIndex() ?? 0;
    final verseNumber = await StorageService.getLastReadVerse() ?? 0;
    final pageNumber = await StorageService.getLastReadPage() ?? 0;
    final lastReadMode = await StorageService.getLastReadMode() ?? '';

    emit(state.copyWith(
      status: LastReadStatus.loaded,
      surahName: surahName,
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      pageNumber: pageNumber,
      lastReadMode: lastReadMode,
      isVisible: _shouldShowLastRead(
          surahNumber, verseNumber, pageNumber, surahName, lastReadMode),
    ));
  }

  void setSurah(String surah) {
    StorageService.setLastReadSurah(surah);
    emit(state.copyWith(surahName: surah));
    _updateVisibility();
  }

  void setSurahIndex(int surahIndex) {
    StorageService.setLastReadSurahIndex(surahIndex);
    emit(state.copyWith(surahNumber: surahIndex));
    _updateVisibility();
  }

  void setVerse(int verse) {
    StorageService.setLastReadVerse(verse);
    StorageService.setLastReadMode('list');
    emit(state.copyWith(verseNumber: verse, lastReadMode: 'list'));
    _updateVisibility();
  }

  void setPage(int page) {
    StorageService.setLastReadPage(page);
    StorageService.setLastReadMode('mushaf');
    emit(state.copyWith(pageNumber: page, lastReadMode: 'mushaf'));
    _updateVisibility();
  }

  void _updateVisibility() {
    emit(state.copyWith(
      isVisible: _shouldShowLastRead(
        state.surahNumber,
        state.verseNumber,
        state.pageNumber,
        state.surahName,
        state.lastReadMode,
      ),
    ));
  }

  bool _shouldShowLastRead(int surahNumber, int verseNumber, int pageNumber,
      String surahName, String lastReadMode) {
    return (lastReadMode == 'list' && surahNumber > 0 && verseNumber > 0) ||
        (lastReadMode == 'mushaf' && surahName.isNotEmpty && pageNumber > 0);
  }
}
