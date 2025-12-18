import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/quran.dart' as quran;

import '../../Core/constant/themes.dart';
import '../../Models/api_reciters.dart';
import '../../core/di/injection.dart';
import '../../features/quran/presentation/cubit/surah_cubit.dart';
import '../../features/quran/presentation/cubit/surah_state.dart';
import '../Quran/package/stack_of_number.dart';
import 'play_surah.dart';

class SurahListScreen extends StatelessWidget {
  final Moshaf moshaf;
  final Reciter reciter;

  const SurahListScreen({
    super.key,
    required this.moshaf,
    required this.reciter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SurahCubit>(),
      child: _SurahListView(moshaf: moshaf, reciter: reciter),
    );
  }
}

class _SurahListView extends StatefulWidget {
  final Moshaf moshaf;
  final Reciter reciter;

  const _SurahListView({required this.moshaf, required this.reciter});

  @override
  State<_SurahListView> createState() => _SurahListViewState();
}

class _SurahListViewState extends State<_SurahListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختار سورة"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'بحث عن سورة...',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<SurahCubit>().filterSearchResults(value);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SurahCubit, SurahState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.filteredSurahNames.length,
            itemBuilder: (context, index) {
              final surahNameArabic = state.filteredSurahNames[index];
              final surahId = state.allSurahNames.indexOf(surahNameArabic) + 1;
              final surahPlace = quran.getPlaceOfRevelation(surahId);
              final surahNameEnglish = quran.getSurahName(surahId);

              return AudioTittle(
                surahName: surahNameArabic,
                surahNameEn: surahNameEnglish,
                totalAya: quran.getVerseCount(surahId),
                surahPlace: surahPlace,
                number: surahId,
                onTap: () {
                  String surahUrl = '${widget.moshaf.server}$surahId.mp3';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaySurah(
                        surahId: surahId,
                        surahUrl: surahUrl,
                        surahName: surahNameArabic,
                        readerName: widget.reciter.name ?? '',
                        moshafName: widget.moshaf.name ?? "",
                        moshaf: widget.moshaf,
                        reciter: widget.reciter,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AudioTittle extends StatelessWidget {
  final String? surahName;
  final String? surahNameEn;
  final int? totalAya;
  final String? surahPlace;
  final int? number;
  final VoidCallback? onTap;

  const AudioTittle({
    super.key,
    required this.surahName,
    required this.surahNameEn,
    required this.totalAya,
    required this.number,
    required this.onTap,
    required this.surahPlace,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StackOfNumber(surahIndex: number.toString()),
                        SizedBox(width: 10.w),
                        Text(
                          surahName ?? '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: TextFontType.quranFont,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      surahNameEn ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                        fontFamily: TextFontType.notoNastaliqUrduFont,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    "آياتها ( $totalAya ) • $surahPlace",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: TextFontType.notoNastaliqUrduFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
