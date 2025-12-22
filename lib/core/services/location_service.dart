import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationService {
  final loc.Location _location;

  LocationService(this._location);

  Future<loc.LocationData> getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionStatus;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }
    }

    permissionStatus = await _location.hasPermission();

    if (permissionStatus == loc.PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != loc.PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    if (permissionStatus == loc.PermissionStatus.deniedForever) {
      await openAppSettings();
      throw Exception(
        'Location permission is permanently denied. Please enable it from settings.',
      );
    }

    return await _location.getLocation();
  }
}
