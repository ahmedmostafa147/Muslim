import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../location/presentation/cubit/location_state.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';

class HomeLocationWidget extends StatelessWidget {
  const HomeLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocationCubit>()..init()),
        BlocProvider(create: (_) => getIt<PrayerTimesCubit>()..init()),
      ],
      child: BlocListener<LocationCubit, LocationState>(
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
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          child: Column(
            children: [
              BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingWidget();
                  }
                  return TextButton(
                    onPressed: () =>
                        context.read<LocationCubit>().getCurrentLocation(),
                    child: Text(
                      state.location.address,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
