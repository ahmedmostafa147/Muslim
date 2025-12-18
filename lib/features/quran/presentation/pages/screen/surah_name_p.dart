import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;
import '../../../core/di/injection.dart';
import '../../../Core/constant/themes.dart';
import '../../../features/quran/presentation/cubit/surah_cubit.dart';
import '../../../features/quran/presentation/cubit/surah_state.dart';
import '../../../widgets/loading_widget.dart';
import '../package/stack_of_number.dart';
import 'select_type.dart';

class ListSurahNamePackage extends StatelessWidget {
  const ListSurahNamePackage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SurahCubit>(),
      child: const _ListSurahNameView(),
    );
  }
}

class _ListSurahNameView extends StatefulWidget {
  const _ListSurahNameView();

  @override
  State<_ListSurahNameView> createState() => _ListSurahNameViewState();
}

class _ListSurahNameViewState extends State<_ListSurahNameView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن')),
      body: BlocBuilder<SurahCubit, SurahState>(
        builder: (context, state) {
          if (state.status == SurahStatus.initial) {
            return const LoadingWidget();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: false,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "ابحث عن اسم السورة ",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<SurahCubit>().filterSearchResults(value);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredSurahNames.length,
                  itemBuilder: (context, index) {
                    final surahNameArabic = state.filteredSurahNames[index];
                    final surahIndex =
                        state.allSurahNames.indexOf(surahNameArabic) + 1;
                    final surahVerseCount = quran.getVerseCount(surahIndex);
                    final surahNameEnglish = quran.getSurahName(surahIndex);
                    final surahPlace = quran.getPlaceOfRevelation(surahIndex);
                    final numOfPage = quran.getPageNumber(surahIndex, 1);

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          builder: (_) => SelectTypeReading(
                            surahIndex: surahIndex,
                            surahVerseCount: surahVerseCount,
                            surahName: surahNameArabic,
                            pageNumber: numOfPage,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        StackOfNumber(
                                            surahIndex: surahIndex.toString()),
                                        SizedBox(width: 10.w),
                                        Text(
                                          surahNameArabic,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: TextFontType.quranFont,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      surahNameEnglish,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily:
                                            TextFontType.notoNastaliqUrduFont,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Center(
                                  child: Text(
                                    "آياتها ( $surahVerseCount ) • $surahPlace",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily:
                                          TextFontType.notoNastaliqUrduFont,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
