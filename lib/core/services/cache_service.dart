import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class CacheService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPrefs;

  CacheService(this._secureStorage, this._sharedPrefs);

  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_done';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<void> setOnboardingDone() async {
    await _sharedPrefs.setBool(_onboardingKey, true);
  }

  bool isOnboardingDone() {
    return _sharedPrefs.getBool(_onboardingKey) ?? false;
  }
}
