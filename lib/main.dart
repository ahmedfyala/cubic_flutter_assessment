import 'package:flutter/material.dart';

import 'app.dart';
import 'config/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();

  runApp(const MyApp());
}
