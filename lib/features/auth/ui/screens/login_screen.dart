import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/service_locator.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/notifier.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/password_form_field.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';
import '../widgets/auth_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoBiometric();
    });
  }

  Future<void> _checkAutoBiometric() async {
    final cache = sl<CacheService>();
    final token = await cache.getToken();

    if (token != null && cache.isBiometricEnabled()) {
      _triggerBiometric();
    }
  }

  Future<void> _triggerBiometric() async {
    final biometric = sl<BiometricService>();
    final authenticated = await biometric.authenticate();
    if (authenticated && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.dashboard,
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.dashboard,
                (route) => false,
              );
            } else if (state is AuthRegisterSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.biometricSetup,
                (route) => false,
              );
            } else if (state is AuthError) {
              Notifier.show(
                context: context,
                message: state.message,
                snackBarType: SnackBarType.error,
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    LocaleKeys.sign_in.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: LocaleKeys.email_address.tr(),
                    hintText: LocaleKeys.email_hint.tr(),
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.r),
                      child: SvgPicture.asset(
                        AppAssets.icEmail,
                        colorFilter: ColorFilter.mode(
                          colorScheme.outline,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 24.h),
                  PasswordFormField(
                    controller: _passwordController,
                    labelText: LocaleKeys.password.tr(),
                    hintText: LocaleKeys.password_hint.tr(),
                    validator: AppValidator.validateLoginPassword,
                  ),
                  SizedBox(height: 48.h),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomElevatedButton(
                        text: LocaleKeys.sign_in.tr(),
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  AuthFooter(
                    question: LocaleKeys.new_user_q.tr(),
                    actionText: LocaleKeys.sign_up.tr(),
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.register),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
