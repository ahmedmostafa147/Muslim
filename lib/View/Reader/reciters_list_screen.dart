import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/di/injection.dart';
import '../../features/reciters/presentation/cubit/reciters_cubit.dart';
import '../../features/reciters/presentation/cubit/reciters_state.dart';
import '../../Models/api_reciters.dart';
import '../../widgets/loading_widget.dart';
import 'list_surah.dart';
import 'type_mushaf.dart';

class RecitersListScreen extends StatelessWidget {
  const RecitersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RecitersCubit>(),
      child: const _RecitersListView(),
    );
  }
}

class _RecitersListView extends StatefulWidget {
  const _RecitersListView();

  @override
  State<_RecitersListView> createState() => _RecitersListViewState();
}

class _RecitersListViewState extends State<_RecitersListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القراء')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<RecitersCubit>().filterReciters(value),
              decoration: InputDecoration(
                hintText: 'ابحث عن القارئ',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RecitersCubit, RecitersState>(
              builder: (context, state) {
                if (state.status == RecitersStatus.loading) {
                  return const Center(child: LoadingWidget());
                }

                return ListView.builder(
                  itemCount: state.filteredRecitersList.length,
                  itemBuilder: (context, index) {
                    final reciter = state.filteredRecitersList[index];
                    return ReaderCustomTile(
                      reciter: reciter,
                      onTap: () {
                        if (reciter.moshaf != null &&
                            reciter.moshaf!.length == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurahListScreen(
                                reciter: reciter,
                                moshaf: reciter.moshaf![0],
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MoshafListScreen(reciter: reciter),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReaderCustomTile extends StatelessWidget {
  final Reciter reciter;
  final VoidCallback onTap;

  const ReaderCustomTile(
      {super.key, required this.reciter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            reciter.name ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
