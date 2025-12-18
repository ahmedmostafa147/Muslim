import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qibla_direction/qibla_direction.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import '../../core/di/injection.dart';
import '../../Core/constant/images.dart';
import '../../features/location/presentation/cubit/location_cubit.dart';
import '../../features/location/presentation/cubit/location_state.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationCubit>()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("القبلة"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () => context
                              .read<LocationCubit>()
                              .getCurrentLocation(),
                      child: state.isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2),
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
                );
              },
            ),
            Expanded(
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  return QiblaCompass(
                    latitude: state.location.latitude,
                    longitude: state.location.longitude,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  final double latitude;
  final double longitude;

  const QiblaCompass({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final qiblaDirection = QiblaDirection.find(Coordinate(latitude, longitude));

    return StreamBuilder<GyroscopeEvent>(
      stream: gyroscopeEventStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error reading heading: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        double compassHeading = snapshot.data?.z ?? 0.0;

        // Check if the Qibla direction is within a certain threshold
        if ((qiblaDirection - compassHeading).abs() < 1) {
          Vibration.vibrate(duration: 500);
        }

        return QiblaCompassWidget(
          compassHeading: compassHeading,
          qiblaDirection: qiblaDirection,
        );
      },
    );
  }
}

class QiblaCompassWidget extends StatelessWidget {
  final double compassHeading;
  final double qiblaDirection;

  const QiblaCompassWidget({
    super.key,
    required this.compassHeading,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrectDirection = compassHeading.round() == qiblaDirection.round();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'اتجاه القبلة: ${qiblaDirection.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'الاتجاه الحالي ${compassHeading.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCorrectDirection
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isCorrectDirection ? 'الاتجاه صحيح' : 'الاتجاه خاطئ حتي الان',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCorrectDirection
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Stack(clipBehavior: Clip.none, children: [
              Transform.rotate(
                angle: (qiblaDirection * 0.0175) +
                    compassHeading * (math.pi / 180) * -1,
                child: Image.asset(Assets.imagesQiblaba,
                    height: 250.h, width: 250.w),
              ),
              Transform.rotate(
                angle: compassHeading * (math.pi / 180) * -1,
                child: Image.asset(Assets.imagesCompass,
                    height: 250.h, width: 250.w),
              ),
              Positioned(
                right: 0,
                left: 0,
                top: -10,
                child: Icon(Icons.arrow_upward_rounded, size: 30.r),
              ),
            ]),
            SizedBox(height: 10.h),
            Text(
              "يجب تشغيل الموقع لتحديد الموقع الحالي\n حتي يتم تحديد الاتجاة بشكل صحيح",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              " حرك الهاتف حتي يتطابق ايقونة القبلة مع اتجاة السهم الاخضر\nو تظهر جملة الاتجاه صحيح و يهتز الهاتف",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              " ابقي الجهاز افقيا و بعيدا عن الاجسام المعدنية فانها قد تتسبب في تشويشات في القياس",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 10.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
