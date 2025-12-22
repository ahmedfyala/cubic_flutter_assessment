import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../data_sources/map_local_data_source.dart';
import '../data_sources/map_remote_data_source.dart';
import '../models/location_model.dart';
import 'map_repo.dart';

@LazySingleton(as: MapRepo)
class MapRepoImpl implements MapRepo {
  final MapRemoteDataSource _remoteDataSource;
  final MapLocalDataSource _localDataSource;

  MapRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<LocationModel>> getNearestLocations(
    double userLat,
    double userLng,
  ) async {
    List<LocationModel> allLocations = await _localDataSource
        .getCachedLocations();

    if (allLocations.isEmpty) {
      final rawData = await _remoteDataSource.fetchRawLocations();
      allLocations = await compute(_parseAndConvert, rawData);
      await _localDataSource.saveLocations(allLocations);
    }

    final List<Map<String, dynamic>> safeData = allLocations
        .map((e) => e.toJson())
        .toList();

    final List<Map<String, dynamic>> nearestMaps = await compute(
      _filterNearest50InIsolate,
      {'data': safeData, 'lat': userLat, 'lng': userLng},
    );

    List<LocationModel> results = nearestMaps
        .map((m) => LocationModel.fromJson(m))
        .toList();

    results.insert(
      0,
      LocationModel(
        id: "TEST-ACTIVE-BRANCH-001",
        name: "Cubic Premium Branch (Test)",
        type: "BRANCH",
        address: "123 Banking St, Cairo, Egypt",
        lat: userLat + 0.002,
        lng: userLng + 0.002,
        isActive: true,
        phone: "+20123456789",
        workingHours: "09:00 AM - 05:00 PM",
        services: ["Customer Service", "Loans", "ATM", "Cards"],
      ),
    );

    return results;
  }
}

List<LocationModel> _parseAndConvert(List<dynamic> raw) {
  return raw
      .map((json) => LocationModel.fromJson(Map<String, dynamic>.from(json)))
      .toList();
}

List<Map<String, dynamic>> _filterNearest50InIsolate(
  Map<String, dynamic> params,
) {
  final List<Map<String, dynamic>> data = params['data'];
  final double uLat = params['lat'];
  final double uLng = params['lng'];

  for (var item in data) {
    item['distance'] = _calculateDistance(
      uLat,
      uLng,
      (item['lat'] as num).toDouble(),
      (item['lng'] as num).toDouble(),
    );
  }

  data.sort(
    (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
  );

  return data.take(50).toList();
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a =
      0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
