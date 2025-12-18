import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../Core/constant/images.dart';
import '../../../../Core/constant/themes.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../location/presentation/cubit/location_state.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../notification/presentation/cubit/notification_state.dart';
import '../cubit/prayer_times_cubit.dart';
import '../cubit/prayer_times_state.dart';
import '../widgets/prayer_time_item.dart';
import '../widgets/date_navigation_row.dart';

class PrayerTimesScreenNew extends StatelessWidget {
  const PrayerTimesScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (_) => getIt<LocationCubit>()..init(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider<PrayerTimesCubit>(
          create: (context) => getIt<PrayerTimesCubit>()..init(),
        ),
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
            // Location snackbar listener
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
                  // Refresh prayer times after location update
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
            // Notification snackbar listener
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
              if (prayerState.status == PrayerTimesStatus.initial ||
                  prayerState.prayerTimes == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const Divider(),
                  _buildDateRow(context),
                  const Divider(),
                  SizedBox(height: 10.h),
                  _buildLocationRow(context),
                  _buildNextPrayerCard(context, prayerState),
                  SizedBox(height: 10.h),
                  DateNavigationRow(
                    selectedDate: prayerState.selectedDate,
                    onPrevious: () =>
                        context.read<PrayerTimesCubit>().decrementDate(),
                    onNext: () =>
                        context.read<PrayerTimesCubit>().incrementDate(),
                  ),
                  _buildPrayerTimesList(context, prayerState),
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

  Widget _buildDateRow(BuildContext context) {
    // Using existing DateRowClass or building inline
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hijri and Gregorian dates will be added here
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: state.isLoading
                    ? null
                    : () => context.read<LocationCubit>().getCurrentLocation(),
                child: state.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
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
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.0,
          ),
          image: DecorationImage(
            image: const AssetImage(Assets.imagesMo),
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
              ],
            ),
            Image(
              image: const AssetImage(Assets.imagesSalahbetween),
              width: 60.w,
              height: 60.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(BuildContext context, PrayerTimesState state) {
    final prayers = [
      {
        'name': 'الفجر',
        'key': 'Fajr',
        'time': state.prayerTimes!.fajr,
        'image': Assets.imagesFajr
      },
      {
        'name': 'الظهر',
        'key': 'Dhuhr',
        'time': state.prayerTimes!.dhuhr,
        'image': Assets.imagesDhuhr
      },
      {
        'name': 'العصر',
        'key': 'Asr',
        'time': state.prayerTimes!.asr,
        'image': Assets.imagesAsr
      },
      {
        'name': 'المغرب',
        'key': 'Maghrib',
        'time': state.prayerTimes!.maghrib,
        'image': Assets.imagesMaghrib
      },
      {
        'name': 'العشاء',
        'key': 'Isha',
        'time': state.prayerTimes!.isha,
        'image': Assets.imagesIsha
      },
    ];

    return Column(
      children: prayers.map((prayer) {
        final isNextPrayer = state.nextPrayer == prayer['key'];
        return PrayerTimeItem(
          name: prayer['name'] as String,
          time: prayer['time'] as String,
          imagePath: prayer['image'] as String,
          isHighlighted: isNextPrayer,
        );
      }).toList(),
    );
  }

  Widget _buildNotificationToggle(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تذكير بمواقيت الصلاة ',
                style: TextStyle(fontSize: 13.sp),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsStyleApp.hoverLight,
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
