import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<UserCredential> login(String email, String password);
  Future<UserCredential> register(String email, String password, String name);
  Future<void> logout();
}
