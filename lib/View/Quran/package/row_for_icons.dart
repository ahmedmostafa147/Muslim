import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/di/injection.dart';
import '../../../features/bookmark/presentation/cubit/bookmark_cubit.dart';
import '../../../features/bookmark/presentation/cubit/bookmark_state.dart';
import '../../../features/favorite/presentation/cubit/favorite_cubit.dart';
import '../../../features/favorite/presentation/cubit/favorite_state.dart';

class RowIconVerse extends StatelessWidget {
  const RowIconVerse({
    super.key,
    required this.verseTextForSurah,
    required this.surahName,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahVerseCount,
    required this.onHeadphonePressed,
  });

  final String verseTextForSurah;
  final String surahName;
  final int surahNumber;
  final int verseNumber;
  final int surahVerseCount;
  final VoidCallback onHeadphonePressed;

  @override
  Widget build(BuildContext context) {
    final verseKey = '$surahNumber:$verseNumber';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BookmarkCubit>()),
        BlocProvider(create: (_) => getIt<FavoriteCubit>()),
      ],
      child: Card(
        elevation: 5,
        child: Row(
          children: [
            IconButton(
              onPressed: onHeadphonePressed,
              icon: const Icon(Icons.headphones_outlined),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: verseTextForSurah));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$surahName - تم نسخ الآية')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareVerse(verseTextForSurah),
            ),
            BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                final isBookmarked = state.isBookmarked(verseKey);
                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  onPressed: () {
                    context.read<BookmarkCubit>().toggleBookmark(verseKey);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isBookmarked
                              ? 'تم إزالة العلامة'
                              : 'تم إضافة العلامة',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                final isFavorite = state.isFavorite(verseKey);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    context.read<FavoriteCubit>().toggleFavorite(verseKey);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'تم إزالة من المفضلة'
                              : 'تم إضافة للمفضلة',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareVerse(String verseText) {
    final String text = '$surahName - $verseText';
    const String subject = 'Quran';
    Share.share(text, subject: subject);
  }
}
