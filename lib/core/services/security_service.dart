import 'package:screen_protector/screen_protector.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecurityService {
  Future<void> preventScreenshots() async {
    await ScreenProtector.preventScreenshotOn();
  }

  Future<void> allowScreenshots() async {
    await ScreenProtector.preventScreenshotOff();
  }
}
