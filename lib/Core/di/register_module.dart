import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Module for registering third-party dependencies
@module
abstract class RegisterModule {
  /// Register SharedPreferences as a singleton
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
