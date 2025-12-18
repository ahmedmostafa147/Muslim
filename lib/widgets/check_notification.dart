import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Core/constant/themes.dart';
import '../core/di/injection.dart';
import '../features/notification/presentation/cubit/notification_cubit.dart';
import '../features/notification/presentation/cubit/notification_state.dart';

class NotificationClass extends StatelessWidget {
  const NotificationClass({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>(),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
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
              ),
              SizedBox(height: 10.h),
              Container(
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
                      'تذكير بالأذكار ',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsStyleApp.hoverLight,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Checkbox(
                        value: state.isAzkarOn,
                        onChanged: (value) => context
                            .read<NotificationCubit>()
                            .toggleAzkar(value),
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          );
        },
      ),
    );
  }
}
