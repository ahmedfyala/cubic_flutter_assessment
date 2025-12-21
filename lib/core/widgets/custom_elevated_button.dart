import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? disabledColor;
  final double height;
  final bool isExpanded;

  const CustomElevatedButton({
    Key? key,
    this.text,
    this.child,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.disabledColor,
    this.height = 52.0,
    this.isExpanded = true,
  }) : assert(
         text != null || child != null,
         'Either text or child must be provided.',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = color ?? theme.colorScheme.primary;
    final finalDisabledColor = disabledColor ?? theme.disabledColor;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return finalDisabledColor;
          }
          return primary;
        }),
        elevation: WidgetStateProperty.resolveWith<double?>((states) {
          if (states.contains(WidgetState.disabled)) {
            return 0;
          }
          return null;
        }),
        minimumSize: WidgetStateProperty.all(
          Size(isExpanded ? double.infinity : 0, height.h),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
              ),
            )
          : child ??
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onPressed != null
                          ? theme.colorScheme.onPrimary
                          : Colors.white.withOpacity(0.8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
    );
  }
}
