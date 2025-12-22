import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'config/service_locator.dart';
import 'core/localizations/app_localizations.dart';
import 'core/routes/route_names.dart';
import 'core/services/cache_service.dart';
import 'core/services/security_service.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/map/data/models/location_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await setupServiceLocator();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0))
    Hive.registerAdapter(LocationModelAdapter());

  final securityService = sl<SecurityService>();
  await securityService.preventScreenshots();

  final cacheService = sl<CacheService>();
  String initialRoute = !cacheService.isOnboardingDone()
      ? RouteNames.splash
      : (await cacheService.getToken() != null
            ? (cacheService.isBiometricEnabled()
                  ? RouteNames.login
                  : RouteNames.dashboard)
            : RouteNames.login);

  runApp(
    EasyLocalization(
      supportedLocales: AppLocalizations.supportedLocales,
      path: AppLocalizations.translationsPath,
      fallbackLocale: AppLocalizations.english,
      startLocale: AppLocalizations.english,
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
