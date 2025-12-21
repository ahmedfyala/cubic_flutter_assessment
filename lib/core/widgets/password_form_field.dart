import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'custom_text_form_field.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const PasswordFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.textInputAction,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      prefixIcon: Padding(
        padding: EdgeInsets.all(14.r),
        child: SvgPicture.asset(
          AppAssets.icLock,
          colorFilter: const ColorFilter.mode(
            AppColors.textGrey,
            BlendMode.srcIn,
          ),
        ),
      ),
      password: true,
      obscureText: _obscureText,
      suffixIconTap: () => setState(() => _obscureText = !_obscureText),
      validator: widget.validator,
      textInputAction: widget.textInputAction,
    );
  }
}
