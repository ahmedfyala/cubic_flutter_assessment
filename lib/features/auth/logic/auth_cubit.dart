import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/services/cache_service.dart';
import '../data/repos/auth_repo.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final CacheService _cacheService;

  AuthCubit(this._authRepo, this._cacheService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _authRepo.login(email, password);
      final token = credential.user?.uid;
      if (token != null) {
        await _cacheService.saveToken(token);

        if (!_cacheService.isBiometricEnabled()) {
          emit(AuthRegisterSuccess());
        } else {
          emit(AuthSuccess());
        }
      } else {
        emit(AuthError("User ID not found"));
      }
    } catch (e) {
      final failure = ErrorHandler.handle(e);
      emit(AuthError(failure.message));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(email, password, name);
      emit(AuthRegisterSuccess());
    } catch (e) {
      final failure = ErrorHandler.handle(e);
      emit(AuthError(failure.message));
    }
  }

  Future<void> logout() async {
    await _cacheService.clearAuthData();
    emit(AuthInitial());
  }
}
