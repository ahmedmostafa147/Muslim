import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/di/injection.dart';
import '../../Core/constant/themes.dart';
import '../../features/notification/presentation/cubit/notification_cubit.dart';
import '../../features/notification/presentation/cubit/notification_state.dart';
import '../../features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../features/prayer_times/presentation/cubit/prayer_times_state.dart';

class NotificationAndPrayerTimesSettingsScreen extends StatelessWidget {
  const NotificationAndPrayerTimesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<NotificationCubit>()),
        BlocProvider(create: (_) => getIt<PrayerTimesCubit>()..init()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('إعدادات الصلاة والإشعارات')),
        body: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
              builder: (context, state) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text('تاريخ الصلاة'),
                      trailing: Text(
                          DateFormat('yyyy-MM-dd').format(state.selectedDate)),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: state.selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          context
                              .read<PrayerTimesCubit>()
                              .changeDate(pickedDate);
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('طريقة الحساب'),
                      trailing: Text(state.calculationMethod),
                    ),
                    ListTile(
                      title: const Text('المذهب'),
                      trailing: Text(state.madhab),
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('تذكير بمواقيت الصلاة'),
                      value: state.isNotificationOn,
                      onChanged: (value) => context
                          .read<NotificationCubit>()
                          .toggleNotification(value),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    SwitchListTile(
                      title: const Text('تذكير بالأذكار'),
                      value: state.isAzkarOn,
                      onChanged: (value) =>
                          context.read<NotificationCubit>().toggleAzkar(value),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
