import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is FirebaseAuthException) {
      return AuthFailure(_mapFirebaseError(error.code));
    } else if (error is DioException) {
      return _handleDioError(error);
    } else {
      return ServerFailure("An unexpected error occurred. Please try again.");
    }
  }

  static String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid login credentials.';
      default:
        return 'Authentication failed. Code: $code';
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure("Connection timed out. Please try again.");
      case DioExceptionType.connectionError:
        return NetworkFailure("No internet connection.");
      default:
        return ServerFailure("Server communication failed.");
    }
  }
}
