import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/cache_service.dart';
import 'biometric_state.dart';

@injectable
class BiometricsCubit extends Cubit<BiometricsState> {
  final BiometricService _biometricService;
  final CacheService _cacheService;

  BiometricsCubit(this._biometricService, this._cacheService)
    : super(BiometricsInitial());

  Future<void> enableBiometrics() async {
    emit(BiometricsLoading());
    try {
      final isSupported = await _biometricService.isDeviceSupported();
      if (!isSupported) {
        emit(
          BiometricsFailure(
            "No biometric features enrolled on this device. Please check your phone settings.",
          ),
        );
        return;
      }

      final authenticated = await _biometricService.authenticate();
      if (authenticated) {
        await _cacheService.setBiometricEnabled(true);
        emit(BiometricsSuccess());
      } else {
        emit(BiometricsFailure("Authentication failed or cancelled."));
      }
    } catch (e) {
      emit(BiometricsFailure("Error: ${e.toString()}"));
    }
  }
}
