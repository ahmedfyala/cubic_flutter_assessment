// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:location/location.dart' as _i645;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/services/biometric_service.dart' as _i379;
import '../core/services/cache_service.dart' as _i800;
import '../core/services/firestore_service.dart' as _i43;
import '../core/services/location_service.dart' as _i848;
import '../core/services/security_service.dart' as _i816;
import '../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i235;
import '../features/auth/data/data_sources/auth_remote_data_source_impl.dart'
    as _i877;
import '../features/auth/data/repos/auth_repo.dart' as _i899;
import '../features/auth/data/repos/auth_repo_impl.dart' as _i353;
import '../features/auth/logic/auth_cubit.dart' as _i329;
import '../features/auth/logic/biometrics_cubit.dart' as _i772;
import '../features/dashboard/logic/dashboard_cubit.dart' as _i297;
import '../features/favorites/data/data_sources/favorites_remote_data_source.dart'
    as _i460;
import '../features/favorites/data/repos/favorites_repo.dart' as _i908;
import '../features/favorites/data/repos/favorites_repo_impl.dart' as _i212;
import '../features/favorites/logic/favorites_cubit.dart' as _i506;
import '../features/map/data/data_sources/map_local_data_source.dart' as _i607;
import '../features/map/data/data_sources/map_remote_data_source.dart' as _i764;
import '../features/map/data/repos/map_repo.dart' as _i117;
import '../features/map/data/repos/map_repo_impl.dart' as _i880;
import '../features/map/logic/map_cubit.dart' as _i556;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs,
      preResolve: true,
    );
    gh.lazySingleton<_i816.SecurityService>(() => _i816.SecurityService());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i645.Location>(() => registerModule.location);
    gh.lazySingleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i848.LocationService>(
        () => _i848.LocationService(gh<_i645.Location>()));
    gh.lazySingleton<_i607.MapLocalDataSource>(
        () => _i607.MapLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i764.MapRemoteDataSource>(
        () => _i764.MapRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i117.MapRepo>(() => _i880.MapRepoImpl(
          gh<_i764.MapRemoteDataSource>(),
          gh<_i607.MapLocalDataSource>(),
        ));
    gh.lazySingleton<_i235.AuthRemoteDataSource>(
        () => _i877.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i379.BiometricService>(
        () => _i379.BiometricService(gh<_i152.LocalAuthentication>()));
    gh.lazySingleton<_i800.CacheService>(() => _i800.CacheService(
          gh<_i558.FlutterSecureStorage>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i43.FirestoreService>(() => _i43.FirestoreService(
          gh<_i974.FirebaseFirestore>(),
          gh<_i59.FirebaseAuth>(),
        ));
    gh.lazySingleton<_i460.FavoritesRemoteDataSource>(
        () => _i460.FavoritesRemoteDataSourceImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i59.FirebaseAuth>(),
            ));
    gh.factory<_i772.BiometricsCubit>(() => _i772.BiometricsCubit(
          gh<_i379.BiometricService>(),
          gh<_i800.CacheService>(),
        ));
    gh.factory<_i297.DashboardCubit>(() => _i297.DashboardCubit(
          gh<_i59.FirebaseAuth>(),
          gh<_i800.CacheService>(),
        ));
    gh.lazySingleton<_i899.AuthRepo>(
        () => _i353.AuthRepoImpl(gh<_i235.AuthRemoteDataSource>()));
    gh.lazySingleton<_i908.FavoritesRepo>(
        () => _i212.FavoritesRepoImpl(gh<_i460.FavoritesRemoteDataSource>()));
    gh.factory<_i329.AuthCubit>(() => _i329.AuthCubit(
          gh<_i899.AuthRepo>(),
          gh<_i800.CacheService>(),
        ));
    gh.factory<_i506.FavoritesCubit>(
        () => _i506.FavoritesCubit(gh<_i908.FavoritesRepo>()));
    gh.factory<_i556.MapCubit>(() => _i556.MapCubit(
          gh<_i117.MapRepo>(),
          gh<_i848.LocationService>(),
          gh<_i43.FirestoreService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
