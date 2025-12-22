import '../models/location_model.dart';

abstract class MapRepo {
  Future<List<LocationModel>> getNearestLocations(
    double userLat,
    double userLng,
  );
}
