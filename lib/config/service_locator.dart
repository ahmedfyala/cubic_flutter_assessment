import 'package:get_it/get_it.dart';
import '../core/services/location_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<LocationService>(() => LocationService());
}
