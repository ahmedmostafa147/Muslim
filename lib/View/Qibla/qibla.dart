import 'dart:math' as math;
import 'package:qibla_direction/qibla_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

import '../../Controller/location.dart';
import '../../Core/constant/images.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Get.put<LocationController>(
      LocationController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("القبلة"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await locationController.getCurrentLocation();
                  },
                  child: Text(
                    locationController.address.value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.location_on,
                ),
              ],
            ),
          ),
          const Expanded(child: Center(child: QiblaCompass())),
        ],
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QiblaController>(
      init: QiblaController(),
      builder: (controller) {
        return StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error reading heading: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            double? compassHeading = snapshot.data?.heading;
            double qiblaDirection = controller.getQiblaDirection();

            // Check if compassHeading is null, indicating that the device does not support this sensor
            if (compassHeading == null) {
              return const Center(
                child: Text("Device does not have sensors!"),
              );
            }
            // Check if the Qibla direction is within a certain threshold
            if ((qiblaDirection - compassHeading).abs() < 1) {
              // Vibrate when Qibla direction becomes correct
              Vibrate.vibrate();
            }
            return QiblaCompassWidget(
              compassHeading: compassHeading,
              qiblaDirection: qiblaDirection,
            );
          },
        );
      },
    );
  }
}

class QiblaCompassWidget extends StatelessWidget {
  final double compassHeading;
  final double qiblaDirection;

  const QiblaCompassWidget({
    Key? key,
    required this.compassHeading,
    required this.qiblaDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCorrectDirection = compassHeading.round() == qiblaDirection.round();

    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                    isCorrectDirection
                        ? 'الاتجاه صحيح'
                        : 'الاتجاه خاطئ حتي الان',
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
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 30.r,
                  ),
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
      ),
    );
  }
}

class QiblaController extends GetxController {
  double getQiblaDirection() {
    LocationController locationController = Get.put<LocationController>(
      LocationController(),
    );
    final qibla = Coordinate(
      locationController.latitude.value,
      locationController.longitude.value,
    );
    return QiblaDirection.find(qibla);
  }
}
