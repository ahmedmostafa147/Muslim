import 'package:equatable/equatable.dart';

/// Location entity representing user's current location
class LocationEntity extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const LocationEntity({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  /// Default location (Cairo, Egypt)
  static const LocationEntity defaultLocation = LocationEntity(
    address: 'اضغط هنا لتحديد الموقع الحالي',
    latitude: 30.007413,
    longitude: 31.4913182,
  );

  @override
  List<Object?> get props => [address, latitude, longitude];
}
