import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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
      }
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError("An unexpected error occurred"));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(email, password, name);
      emit(AuthRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError("Registration failed"));
    }
  }

  Future<void> logout() async {
    await _cacheService.clearAuthData();
    await FirebaseAuth.instance.signOut();
    emit(AuthInitial());
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
