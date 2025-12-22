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
    return canCheckBiometrics && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            signInHint: 'Verify your identity',
            cancelButton: 'Cancel',
          ),
        ],
      );
    } catch (e) {
      return false;
    }
  }
}
