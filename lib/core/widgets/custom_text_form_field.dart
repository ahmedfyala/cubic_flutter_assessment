import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final bool password;
  final bool obscureText;
  final VoidCallback? suffixIconTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.password = false,
    this.obscureText = false,
    this.suffixIconTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 8.h),
            child: Text(
              labelText!,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          enableInteractiveSelection: false,
          contextMenuBuilder: (context, editableTextState) {
            return const SizedBox.shrink();
          },
          style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.4),
              fontSize: 14.sp,
            ),
            fillColor: colorScheme.surface,
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: password
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.onSurface.withOpacity(0.5),
                      size: 20.sp,
                    ),
                    onPressed: suffixIconTap,
                  )
                : null,
            border: _buildBorder(colorScheme.surface),
            enabledBorder: _buildBorder(colorScheme.surface),
            focusedBorder: _buildBorder(colorScheme.primary, width: 1.5),
            errorBorder: _buildBorder(colorScheme.error, width: 1),
            focusedErrorBorder: _buildBorder(colorScheme.error, width: 1.5),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }
}
