import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../core/di/injection.dart';
import '../features/date/presentation/cubit/date_cubit.dart';
import '../features/date/presentation/cubit/date_state.dart';

class DateRowClass extends StatelessWidget {
  const DateRowClass({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DateCubit>(),
      child: BlocBuilder<DateCubit, DateState>(
        builder: (context, state) {
          final hijriDate = state.hijriDate;
          final gregorianDate = state.gregorianDate;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('EEEE', 'ar').format(gregorianDate),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(gregorianDate),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
