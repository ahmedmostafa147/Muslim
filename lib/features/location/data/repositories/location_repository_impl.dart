import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final SharedPreferences _prefs;

  LocationRepositoryImpl(this._prefs);

  static const String _addressKey = 'address';
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';

  @override
  Future<LocationEntity> getCurrentLocation() async {
    // Check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Set locale for Arabic addresses
    await setLocaleIdentifier("ar_SA");

    // Get current position
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // Get address from coordinates
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final Placemark place = placemarks.first;
    final String address = "${place.locality} ${place.country}";

    final location = LocationEntity(
      address: address,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    // Save to storage
    await saveLocation(location);

    return location;
  }

  @override
  Future<LocationEntity> getSavedLocation() async {
    final String? address = _prefs.getString(_addressKey);
    final double? latitude = _prefs.getDouble(_latitudeKey);
    final double? longitude = _prefs.getDouble(_longitudeKey);

    if (address != null && latitude != null && longitude != null) {
      return LocationEntity(
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
    }

    return LocationEntity.defaultLocation;
  }

  @override
  Future<void> saveLocation(LocationEntity location) async {
    await _prefs.setString(_addressKey, location.address);
    await _prefs.setDouble(_latitudeKey, location.latitude);
    await _prefs.setDouble(_longitudeKey, location.longitude);
  }
}
