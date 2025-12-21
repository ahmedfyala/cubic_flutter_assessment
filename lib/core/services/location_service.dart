import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  final Location _location = Location();

  Future<LocationData> getCurrentLocation() async {
    await _handlePermission();
    await _ensureServiceEnabled();
    return await _location.getLocation();
  }

  Future<void> _handlePermission() async {
    final status = await Permission.location.status;

    if (status.isDenied) {
      final result = await Permission.location.request();
      if (!result.isGranted) {
        throw Exception('Location permission denied');
      }
    }

    if (status.isPermanentlyDenied) {
      throw Exception('Location permission permanently denied');
    }
  }

  Future<void> _ensureServiceEnabled() async {
    bool enabled = await _location.serviceEnabled();
    if (!enabled) {
      enabled = await _location.requestService();
      if (!enabled) {
        throw Exception('Location service disabled');
      }
    }
  }
}
