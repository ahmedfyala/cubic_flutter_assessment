import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'config/service_locator.dart';
import 'core/localizations/app_localizations.dart';
import 'core/routes/route_names.dart';
import 'core/services/cache_service.dart';
import 'firebase_options.dart';
import 'features/map/data/models/location_model.dart';




class BootstrapResult {
  final String initialRoute;
  const BootstrapResult(this.initialRoute);
}




void bootstrapIsolate(SendPort sendPort) async {
  
  

  
  await Future.delayed(const Duration(milliseconds: 10));

  sendPort.send(const BootstrapResult(RouteNames.splash));
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  
  await EasyLocalization.ensureInitialized();

  
  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());

  
  await setupServiceLocator();

  
  final receivePort = ReceivePort();
  await Isolate.spawn(bootstrapIsolate, receivePort.sendPort);
  await receivePort.first; 

  
  final cacheService = sl<CacheService>();

  String initialRoute;
  if (!cacheService.isOnboardingDone()) {
    initialRoute = RouteNames.splash;
  } else {
    final token = await cacheService.getToken();
    initialRoute = token != null ? RouteNames.dashboard : RouteNames.login;
  }

  
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
