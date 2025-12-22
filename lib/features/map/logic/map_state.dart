import '../data/models/location_model.dart';

sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapSuccess extends MapState {
  final List<LocationModel> locations;
  final double userLat;
  final double userLng;

  MapSuccess({
    required this.locations,
    required this.userLat,
    required this.userLng,
  });
}

final class MapError extends MapState {
  final String message;

  MapError({required this.message});
}
