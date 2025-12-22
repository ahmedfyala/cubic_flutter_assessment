import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<void> getNearestBranches(Function(LocationModel) onMarkerTap) async {
    emit(MapLoading());
    try {
      final userLocation = await _locationService.getCurrentLocation();
      final double lat = userLocation.latitude ?? 30.0444;
      final double lng = userLocation.longitude ?? 31.2357;

      final result = await _mapRepo.getNearestLocations(lat, lng);

      // بناء الماركرز مع منطق الشرط المطلوب
      final markers = _buildMarkers(result.locations, onMarkerTap);

      emit(
        MapSuccess(
          locations: result.locations,
          markers: markers,
          userLat: lat,
          userLng: lng,
          isFromCache: result.isFromCache,
        ),
      );
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }

  Set<Marker> _buildMarkers(
    List<LocationModel> locations,
    Function(LocationModel) onMarkerTap,
  ) {
    return locations.map((loc) {
      return Marker(
        markerId: MarkerId(loc.id),
        position: LatLng(loc.lat, loc.lng),
        // إذا كان نشط، نستخدم الـ Callback لفتح الشيت، وإلا نترك الـ onTap فارغاً ليظهر الـ InfoWindow
        onTap: loc.isActive ? () => onMarkerTap(loc) : null,
        // إظهار الفقاعة العلوية فقط للفروع غير النشطة كما طلبت
        infoWindow: loc.isActive
            ? InfoWindow.noText
            : InfoWindow(title: loc.name, snippet: loc.address),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          loc.type == 'BRANCH'
              ? BitmapDescriptor.hueAzure
              : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }

  Future<bool> addToFavorites(LocationModel location) async {
    try {
      await _firestoreService.addToFavorites(location);
      _favoritesCache.add(location.id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFromFavorites(String locationId) async {
    try {
      await _firestoreService.removeFromFavorites(locationId);
      _favoritesCache.remove(locationId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkIsFavorite(String locationId) async {
    if (_favoritesCache.contains(locationId)) return true;
    try {
      final isFav = await _firestoreService.isFavorite(locationId);
      if (isFav) _favoritesCache.add(locationId);
      return isFav;
    } catch (_) {
      return false;
    }
  }
}
