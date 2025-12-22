import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationService {
  final loc.Location _location = loc.Location();

  Future<loc.LocationData> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    // 1. التأكد من أن خدمة الـ GPS مفعلة في الجهاز
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }
    }

    // 2. التحقق من صلاحيات التطبيق باستخدام permission_handler لضمان دقة أعلى
    permissionStatus = await Permission.locationWhenInUse.status;

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus.isDenied) {
        throw Exception('Location permission denied');
      }
    }

    if (permissionStatus.isPermanentlyDenied) {
      // إذا رفض المستخدم الصلاحية نهائياً، نوجهه للإعدادات
      await openAppSettings();
      throw Exception(
        'Location permission is permanently denied. Please enable it from settings.',
      );
    }

    // 3. جلب الإحداثيات
    return await _location.getLocation();
  }
}
