import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../data_sources/auth_remote_data_source.dart';
import 'auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  Future<UserCredential> login(String email, String password) async {
    return await _remoteDataSource.login(email, password);
  }

  @override
  Future<UserCredential> register(
    String email,
    String password,
    String name,
  ) async {
    return await _remoteDataSource.register(email, password, name);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }
}
