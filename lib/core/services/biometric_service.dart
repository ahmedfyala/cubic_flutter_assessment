import 'package:local_auth/local_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BiometricService {
  final LocalAuthentication _auth;

  BiometricService(this._auth);

  Future<bool> isDeviceSupported() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    return await _auth.authenticate(
      localizedReason: 'Please authenticate to access your banking account',
    );
  }
}
