import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/locale_keys.g.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onLogoutTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.welcome_back.tr(),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              userName,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onLogoutTap,
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.error.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }
}
