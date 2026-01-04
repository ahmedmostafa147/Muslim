import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muslim/core/di/injection.dart';
import 'package:muslim/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:muslim/features/prayer_times/presentation/cubit/prayer_times_state.dart';

class PrayerTimesSettingsScreen extends StatelessWidget {
  const PrayerTimesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrayerTimesCubit>()..init(),
      child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          return Column(
            children: [
              ListTile(
                title: const Text('تاريخ الصلاة'),
                trailing:
                    Text(DateFormat('yyyy-MM-dd').format(state.selectedDate)),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: state.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    context.read<PrayerTimesCubit>().changeDate(pickedDate);
                  }
                },
              ),
              ListTile(
                title: const Text('طريقة الحساب'),
                trailing: Text(state.calculationMethod),
                onTap: () {
                  _showCalculationMethodPicker(context);
                },
              ),
              ListTile(
                title: const Text('المذهب'),
                trailing: Text(state.madhab),
                onTap: () {
                  _showMadhabPicker(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCalculationMethodPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Egyptian General Authority of Survey'),
              onTap: () {
                context.read<PrayerTimesCubit>().changeCalculationMethod('5');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Muslim World League'),
              onTap: () {
                context.read<PrayerTimesCubit>().changeCalculationMethod('3');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Umm Al-Qura University'),
              onTap: () {
                context.read<PrayerTimesCubit>().changeCalculationMethod('4');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMadhabPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Shafi'),
              onTap: () {
                context.read<PrayerTimesCubit>().changeMadhab('Shafi');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Hanafi'),
              onTap: () {
                context.read<PrayerTimesCubit>().changeMadhab('Hanafi');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
