import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../generated/locale_keys.g.dart';

sealed class BiometricsState {}

final class BiometricsInitial extends BiometricsState {}

final class BiometricsLoading extends BiometricsState {}

final class BiometricsSuccess extends BiometricsState {}

final class BiometricsFailure extends BiometricsState {
  final String message;
  BiometricsFailure(this.message);
}

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
        emit(BiometricsFailure(LocaleKeys.biometrics_not_supported.tr()));
        return;
      }

      final authenticated = await _biometricService.authenticate();
      if (authenticated) {
        await _cacheService.setBiometricEnabled(true);
        emit(BiometricsSuccess());
      } else {
        emit(BiometricsFailure(LocaleKeys.auth_failed.tr()));
      }
    } catch (e) {
      emit(BiometricsFailure(LocaleKeys.operation_failed.tr()));
    }
  }
}
