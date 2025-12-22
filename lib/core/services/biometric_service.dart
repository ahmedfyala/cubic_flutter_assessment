import 'package:local_auth/local_auth.dart';
import 'package:injectable/injectable.dart';

import 'package:local_auth_android/local_auth_android.dart';

@lazySingleton
class BiometricService {
  final LocalAuthentication _auth;

  BiometricService(this._auth);

  Future<bool> isDeviceSupported() async {
    final bool canCheckBiometrics = await _auth.canCheckBiometrics;
    final bool isDeviceSupported = await _auth.isDeviceSupported();
    return canCheckBiometrics || isDeviceSupported;
  }

  Future<bool> authenticate() async {
    try {
      final bool available = await isDeviceSupported();
      if (!available) return false;

      
      
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your banking account',
        biometricOnly: false,
      );
    } catch (e) {
      return false;
    }
  }
}
