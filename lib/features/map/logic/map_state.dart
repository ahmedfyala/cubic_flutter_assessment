import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/models/location_model.dart';

sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapSuccess extends MapState {
  final List<LocationModel> locations;
  final Set<Marker> markers;
  final double userLat;
  final double userLng;
  final bool isFromCache; 

  MapSuccess({
    required this.locations,
    required this.markers,
    required this.userLat,
    required this.userLng,
    this.isFromCache = false,
  });
}

final class MapError extends MapState {
  final String message;
  MapError({required this.message});
}
