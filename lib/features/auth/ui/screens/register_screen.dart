import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/notifier.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/password_form_field.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_state.dart';
import '../widgets/auth_footer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            if (state is AuthRegisterSuccess) {
              Notifier.show(
                context: context,
                message: "Account Created! Please Sign In",
                type: NotificationType.toast,
              );
              Navigator.pop(context);
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
              autovalidateMode: _autoValidate, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.onSurface,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    LocaleKeys.sign_up.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: LocaleKeys.full_name.tr(),
                    hintText: LocaleKeys.full_name_hint.tr(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.r),
                      child: SvgPicture.asset(
                        AppAssets.icName,
                        color: AppColors.textGrey,
                      ),
                    ),
                    validator: AppValidator.validateFullName,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: LocaleKeys.email_address.tr(),
                    hintText: LocaleKeys.email_hint.tr(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.r),
                      child: SvgPicture.asset(
                        AppAssets.icEmail,
                        color: AppColors.textGrey,
                      ),
                    ),
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 20.h),
                  PasswordFormField(
                    controller: _passwordController,
                    labelText: LocaleKeys.password.tr(),
                    hintText: LocaleKeys.password_hint.tr(),
                    validator: AppValidator.validatePasswordStrict,
                  ),
                  SizedBox(height: 20.h),
                  PasswordFormField(
                    controller: _confirmPasswordController,
                    labelText: LocaleKeys.confirm_password.tr(),
                    hintText: LocaleKeys.confirm_password_hint.tr(),
                    validator: (value) => AppValidator.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomElevatedButton(
                        text: LocaleKeys.sign_up.tr(),
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          
                          setState(() {
                            _autoValidate = AutovalidateMode.onUserInteraction;
                          });

                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                              _emailController.text.trim(),
                              _passwordController.text,
                              _nameController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  AuthFooter(
                    question: LocaleKeys.already_have_account.tr(),
                    actionText: LocaleKeys.sign_in.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
