import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:muslim/core/constants/images.dart';
import 'package:muslim/core/constants/themes.dart';
import 'package:muslim/features/location/presentation/cubit/location_cubit.dart';
import 'package:muslim/features/location/presentation/cubit/location_state.dart';
import 'package:muslim/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:muslim/features/notification/presentation/cubit/notification_state.dart';
import 'package:muslim/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:muslim/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import '../../../../core/di/injection.dart';

import 'widget/prayer_column_items.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PrayerTimesCubit>()..init()),
        BlocProvider(create: (_) => getIt<LocationCubit>()..init()),
        BlocProvider(create: (_) => getIt<NotificationCubit>()),
      ],
      child: const _PrayerTimesView(),
    );
  }
}

class _PrayerTimesView extends StatelessWidget {
  const _PrayerTimesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<LocationCubit, LocationState>(
              listenWhen: (prev, curr) =>
                  prev.successMessage != curr.successMessage ||
                  prev.errorMessage != curr.errorMessage,
              listener: (context, state) {
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage!),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                  context.read<LocationCubit>().clearMessages();
                  context.read<PrayerTimesCubit>().updatePrayerTimes();
                }
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  context.read<LocationCubit>().clearMessages();
                }
              },
            ),
            BlocListener<NotificationCubit, NotificationState>(
              listenWhen: (prev, curr) =>
                  prev.successMessage != curr.successMessage,
              listener: (context, state) {
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage!),
                      backgroundColor:
                          state.isNotificationOn ? Colors.teal : Colors.red,
                    ),
                  );
                  context.read<NotificationCubit>().clearMessages();
                }
              },
            ),
          ],
          child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, prayerState) {
              if (prayerState.prayerTimes == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const Divider(),
                 
                  const Divider(),
                  SizedBox(height: 10.h),
                  _buildLocationRow(context),
                  _buildNextPrayerCard(context, prayerState),
                  SizedBox(height: 10.h),
                  _buildDateNavigation(context, prayerState),
                  _buildPrayerList(context, prayerState),
                  SizedBox(height: 10.h),
                  _buildNotificationToggle(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () =>
                          context.read<LocationCubit>().getCurrentLocation(),
                  child: state.isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          state.location.address,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                ),
                const Icon(Icons.location_on),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextPrayerCard(BuildContext context, PrayerTimesState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
          image: DecorationImage(
            image: const AssetImage(Assets.imagesRadio),
            fit: BoxFit.cover,
            opacity:
                Theme.of(context).brightness == Brightness.dark ? 0.4 : 0.9,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الصلاة القادمة هي صلاة",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  state.nextPrayerName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "الوقت المتبقي",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  state.timeRemaining,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
            Image(
              image: const AssetImage(Assets.imagesRadio),
              width: 60.w,
              height: 60.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigation(BuildContext context, PrayerTimesState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => context.read<PrayerTimesCubit>().decrementDate(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(DateFormat('EEE dd MMM yyyy', 'ar').format(state.selectedDate)),
        IconButton(
          onPressed: () => context.read<PrayerTimesCubit>().incrementDate(),
          icon: const Icon(Icons.navigate_next),
        ),
      ],
    );
  }

  Widget _buildPrayerList(BuildContext context, PrayerTimesState state) {
    return Column(
      children: [
        BuildPrayerTimeItemColumn(
          name: 'الفجر',
          imagePath: Assets.imagesRadio,
          time: state.prayerTimes!.fajr,
          containerColor: state.nextPrayer == 'Fajr'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        BuildPrayerTimeItemColumn(
          name: 'الظهر',
          imagePath: Assets.imagesRadio,
          time: state.prayerTimes!.dhuhr,
          containerColor: state.nextPrayer == 'Dhuhr'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        BuildPrayerTimeItemColumn(
          name: 'العصر',
          imagePath: Assets.imagesRadio,
          time: state.prayerTimes!.asr,
          containerColor: state.nextPrayer == 'Asr'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        BuildPrayerTimeItemColumn(
          name: 'المغرب',
          imagePath: Assets.imagesRadio,
          time: state.prayerTimes!.maghrib,
          containerColor: state.nextPrayer == 'Maghrib'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        BuildPrayerTimeItemColumn(
          name: 'العشاء',
          imagePath: Assets.imagesRadio,
          time: state.prayerTimes!.isha,
          containerColor: state.nextPrayer == 'Isha'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تذكير بمواقيت الصلاة ', style: TextStyle(fontSize: 13.sp)),
              Container(
                decoration: BoxDecoration(
                  color: ColorsStyleApp.gold,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Checkbox(
                  value: state.isNotificationOn,
                  onChanged: (value) => context
                      .read<NotificationCubit>()
                      .toggleNotification(value),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
