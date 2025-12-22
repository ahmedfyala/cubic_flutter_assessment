import '../models/location_model.dart';

class LocationResult {
  final List<LocationModel> locations;
  final bool isFromCache;
  LocationResult(this.locations, this.isFromCache);
}

abstract class MapRepo {
  Future<LocationResult> getNearestLocations(double userLat, double userLng);
}
