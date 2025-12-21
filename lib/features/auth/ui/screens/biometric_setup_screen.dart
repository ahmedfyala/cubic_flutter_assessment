import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/notifier.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../logic/biometrics_cubit.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocListener<BiometricsCubit, BiometricsState>(
        listener: (context, state) {
          if (state is BiometricsSuccess) {
            Notifier.show(
              context: context,
              message: "Security Enabled!",
              snackBarType: SnackBarType.success,
            );
            Navigator.pushReplacementNamed(context, RouteNames.dashboard);
          } else if (state is BiometricsFailure) {
            Notifier.show(
              context: context,
              message: state.message,
              snackBarType: SnackBarType.error,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.fingerprint,
                size: 100.r,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 40.h),
              Text(
                "Biometric Authentication",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                "Use Face ID or Touch ID for faster and secure access to your account in the future.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomElevatedButton(
                text: "Enable Biometrics",
                onPressed: () =>
                    context.read<BiometricsCubit>().enableBiometrics(),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RouteNames.dashboard,
                ),
                child: Text(
                  "Maybe Later",
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
