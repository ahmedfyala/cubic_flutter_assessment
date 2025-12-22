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
      print("Starting Firebase Auth for: $email");
      final credential = await _authRepo.login(email, password);

      final token = credential.user?.uid;
      if (token != null) {
        print("Firebase Auth Success. UID: $token");

        try {
          print("Attempting to save token to SecureStorage...");
          await _cacheService.saveToken(token);
          print("Token saved successfully.");
        } catch (storageError) {
          print("CRITICAL: SecureStorage failed: $storageError");
          // في حال فشل التخزين (مشكلة شائعة في المحاكي)، سنكمل العملية لكي لا يعلق التطبيق
        }

        emit(AuthSuccess());
      } else {
        emit(AuthError("User ID not found."));
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Login Error Code: ${e.code}");
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      print("General Login Error: $e");
      emit(AuthError("An unexpected error occurred."));
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
      emit(AuthError("Registration failed."));
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
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
