import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import 'qibla_state.dart';

@injectable
class QiblaCubit extends Cubit<QiblaState> {
  final LocationCubit _locationCubit;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  // Kaaba coordinates
  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  QiblaCubit(this._locationCubit) : super(const QiblaState());

  /// Initialize qibla direction
  Future<void> init() async {
    emit(state.copyWith(status: QiblaStatus.loading));

    try {
      final location = _locationCubit.state.location;
      final qiblaDirection = _calculateQiblaDirection(
        location.latitude,
        location.longitude,
      );

      emit(state.copyWith(
        status: QiblaStatus.loaded,
        qiblaDirection: qiblaDirection,
      ));

      _startCompass();
    } catch (e) {
      emit(state.copyWith(
        status: QiblaStatus.error,
        errorMessage: 'فشل في تحديد اتجاه القبلة',
      ));
    }
  }

  /// Calculate qibla direction from given coordinates
  double _calculateQiblaDirection(double latitude, double longitude) {
    final latRad = latitude * (math.pi / 180);
    final lonRad = longitude * (math.pi / 180);
    final kaabaLatRad = _kaabaLatitude * (math.pi / 180);
    final kaabaLonRad = _kaabaLongitude * (math.pi / 180);

    final lonDiff = kaabaLonRad - lonRad;

    final y = math.sin(lonDiff);
    final x = math.cos(latRad) * math.tan(kaabaLatRad) -
        math.sin(latRad) * math.cos(lonDiff);

    var qibla = math.atan2(y, x) * (180 / math.pi);
    qibla = (qibla + 360) % 360;

    return qibla;
  }

  /// Start listening to magnetometer for compass heading
  void _startCompass() {
    _magnetometerSubscription = magnetometerEventStream().listen((event) {
      final heading = _calculateHeading(event.x, event.y);
      emit(state.copyWith(deviceHeading: heading));
    });
  }

  /// Calculate device heading from magnetometer readings
  double _calculateHeading(double x, double y) {
    var heading = math.atan2(y, x) * (180 / math.pi);
    heading = (heading + 360) % 360;
    return heading;
  }

  /// Recalculate qibla when location changes
  void recalculateQibla() {
    final location = _locationCubit.state.location;
    final qiblaDirection = _calculateQiblaDirection(
      location.latitude,
      location.longitude,
    );
    emit(state.copyWith(qiblaDirection: qiblaDirection));
  }

  @override
  Future<void> close() {
    _magnetometerSubscription?.cancel();
    return super.close();
  }
}
