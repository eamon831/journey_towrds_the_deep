import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_keys.dart';

/// SessionManager class is used to manage the user session.
/// It uses SharedPreferences to store and retrieve session data.
class SessionManager {
  late SharedPreferences prefs;

  /// Singleton instance of SessionManager.
  static SessionManager? _instance;

  factory SessionManager() => _instance ??= SessionManager._internal();

  SessionManager._internal();

  /// Factory method to get the instance of SessionManager.
  factory SessionManager.getInstance() {
    return SessionManager();
  }

  /// Initialize the SharedPreferences instance.
  Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // Handle initialization error, log the error, or throw it further.
      if (kDebugMode) {
        print('Error initializing SharedPreferences: $e');
      }
    }
  }

  /// get boolean value from shared preferences
  Future<bool> getBool(String key) async {
    return prefs.getBool(key) ?? false;
  }

  /// set boolean value in shared preferences
  Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await prefs.setBool(
      key,
      value,
    );
  }

  /// get string value from shared preferences
  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  /// set string value in shared preferences
  Future<void> setString({
    required String key,
    required String value,
  }) async {
    await prefs.setString(
      key,
      value,
    );
  }

  /// get int value from shared preferences
  Future<int?> getInt(String key) async {
    return prefs.getInt(key);
  }

  /// set int value in shared preferences
  Future<void> setInt({
    required String key,
    required int value,
  }) async {
    await prefs.setInt(
      key,
      value,
    );
  }

  /// get double value from shared preferences
  Future<double?> getDouble(String key) async {
    return prefs.getDouble(key);
  }

  /// set double value in shared preferences
  Future<void> setDouble({
    required String key,
    required double value,
  }) async {
    await prefs.setDouble(
      key,
      value,
    );
  }
}
