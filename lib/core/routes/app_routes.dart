import 'package:flutter/material.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _material(
          const Scaffold(body: Center(child: Text('Splash Screen'))),
        );

      case RouteNames.login:
        return _material(
          const Scaffold(body: Center(child: Text('Login Screen'))),
        );

      case RouteNames.dashboard:
        return _material(
          const Scaffold(body: Center(child: Text('Dashboard Screen'))),
        );

      case RouteNames.branchesMap:
        return _material(
          const Scaffold(body: Center(child: Text('Branches Map Screen'))),
        );

      default:
        return _material(
          const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }

  static MaterialPageRoute _material(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
