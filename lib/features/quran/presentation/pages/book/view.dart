import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/features/quran/presentation/cubit/last_read_cubit.dart';
import 'package:muslim/features/widgets/loading_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:muslim/core/constants/themes.dart';
import 'package:muslim/core/di/injection.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/tafseer_cubit.dart';
import 'package:muslim/features/quran/presentation/presentation/cubit/tafseer_state.dart';

import 'tafser.dart';

class QuranImagesScreen extends StatelessWidget {
  const QuranImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final int pageNumber = arguments['pageNumber'] as int? ?? 1;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TafseerCubit>()),
        BlocProvider(create: (_) => getIt<LastReadCubit>()),
      ],
      child: _QuranImagesView(initialPageNumber: pageNumber),
    );
  }
}

class _QuranImagesView extends StatefulWidget {
  final int initialPageNumber;

  const _QuranImagesView({required this.initialPageNumber});

  @override
  State<_QuranImagesView> createState() => _QuranImagesViewState();
}

class _QuranImagesViewState extends State<_QuranImagesView> {
  late PreloadPageController _pageController;

  // Quran page images follow a pattern based on page number
  String getPageImageUrl(int pageNumber) {
    final formattedPage = pageNumber.toString().padLeft(3, '0');
    return 'https://cdn.islamic.network/quran/images/$formattedPage.png';
  }

  @override
  void initState() {
    super.initState();
    _pageController =
        PreloadPageController(initialPage: widget.initialPageNumber - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TafseerCubit, TafseerState>(
      builder: (context, state) {
        if (state.status == TafseerStatus.loading) {
          return const Scaffold(body: LoadingWidget());
        }

        return PreloadPageView.builder(
          controller: _pageController,
          itemCount: 604, // Total pages in Quran
          preloadPagesCount: 2,
          itemBuilder: (context, index) {
            final currentPage = index + 1;
            final imageUrl = getPageImageUrl(currentPage);

            final ayahs =
                context.read<TafseerCubit>().getAyahsByPage(currentPage);
            final surah =
                context.read<TafseerCubit>().getSurahByPage(currentPage);

            // Save last read position
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (surah != null) {
                final lastReadCubit = context.read<LastReadCubit>();
                lastReadCubit.setSurah(surah.name);
                lastReadCubit.setPage(currentPage);
              }
            });

            return Scaffold(
              appBar: AppBar(
                title: const Text('القرآن'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TafseerScreen(pageNumber: currentPage),
                        ),
                      );
                    },
                    icon: const Icon(Icons.book),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (ayahs != null && ayahs.isNotEmpty)
                          Text(
                            'الجزء: ${ayahs.first.juz}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: TextFontType.cairoFont,
                            ),
                          ),
                        if (surah != null)
                          Text(
                            surah.name,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: TextFontType.quranFont,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          color: Theme.of(context).primaryColor,
                          imageUrl: imageUrl,
                          placeholder: (context, url) => const LoadingWidget(),
                          errorWidget: (context, url, error) =>
                              const Text("فشل التحميل"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      '$currentPage',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
