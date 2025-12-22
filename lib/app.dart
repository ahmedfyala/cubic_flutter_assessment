import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/service_locator.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/notifier.dart';
import 'features/connectivity/logic/connectivity_cubit.dart';

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isPaused =
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<ConnectivityCubit>())],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cubic Banking',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: widget.initialRoute,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            builder: (context, child) {
              return BlocListener<ConnectivityCubit, ConnectivityStatus>(
                listener: (context, status) {
                  if (status == ConnectivityStatus.disconnected) {
                    Notifier.show(
                      context: context,
                      message: "No Internet Connection",
                      type: NotificationType.toast,
                      bgColor: Colors.red,
                    );
                  } else if (status == ConnectivityStatus.connected) {
                    Notifier.show(
                      context: context,
                      message: "Internet Restored",
                      type: NotificationType.toast,
                      bgColor: Colors.green,
                    );
                  }
                },
                child: Stack(
                  children: [
                    child!,
                    if (_isPaused)
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: Icon(
                            Icons.lock_outline,
                            size: 80.r,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
