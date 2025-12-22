import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/service_locator.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/auth/logic/biometrics_cubit.dart';
import '../../features/auth/ui/screens/biometric_setup_screen.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/register_screen.dart';
import '../../features/dashboard/logic/dashboard_cubit.dart';
import '../../features/dashboard/ui/screens/dashboard_screen.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/map/logic/map_cubit.dart';
import '../../features/map/ui/screens/branches_map_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _material(const OnboardingScreen());

      case RouteNames.login:
        return _material(
          BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );

      case RouteNames.register:
        return _material(
          BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case RouteNames.biometricSetup:
        return _material(
          BlocProvider(
            create: (context) => sl<BiometricsCubit>(),
            child: const BiometricSetupScreen(),
          ),
        );

      case RouteNames.dashboard:
        return _material(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<AuthCubit>()),
              BlocProvider(create: (context) => sl<DashboardCubit>()),
            ],
            child: const DashboardScreen(),
          ),
        );

      case RouteNames.branchesMap:
        return _material(
          BlocProvider(
            create: (context) => sl<MapCubit>(),
            child: const BranchesMapScreen(),
          ),
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
