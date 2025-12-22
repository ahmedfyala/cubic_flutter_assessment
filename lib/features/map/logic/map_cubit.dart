import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/firestore_service.dart';
import '../data/repos/map_repo.dart';
import '../data/models/location_model.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final MapRepo _mapRepo;
  final LocationService _locationService;
  final FirestoreService _firestoreService;
  final Set<String> _favoritesCache = {};

  MapCubit(this._mapRepo, this._locationService, this._firestoreService)
    : super(MapInitial());

  Future<void> getNearestBranches() async {
    emit(MapLoading());
    try {
      final userLocation = await _locationService.getCurrentLocation();
      final locations = await _mapRepo.getNearestLocations(
        userLocation.latitude!,
        userLocation.longitude!,
      );
      emit(
        MapSuccess(
          locations: locations,
          userLat: userLocation.latitude!,
          userLng: userLocation.longitude!,
        ),
      );
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }

  Future<bool> addToFavorites(LocationModel location) async {
    try {
      _favoritesCache.add(location.id);
      await _firestoreService.addToFavorites(location);
      return true;
    } catch (_) {
      _favoritesCache.remove(location.id);
      return false;
    }
  }

  Future<bool> removeFromFavorites(String locationId) async {
    try {
      _favoritesCache.remove(locationId);
      await _firestoreService.removeFromFavorites(locationId);
      return true;
    } catch (_) {
      _favoritesCache.add(locationId);
      return false;
    }
  }

  Future<bool> checkIsFavorite(String locationId) async {
    if (_favoritesCache.contains(locationId)) {
      return true;
    }
    final isFav = await _firestoreService.isFavorite(locationId);
    if (isFav) {
      _favoritesCache.add(locationId);
    }
    return isFav;
  }
}
