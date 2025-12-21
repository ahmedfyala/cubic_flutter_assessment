import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthFooter extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$question ',
                style: TextStyle(
                  color: const Color(0xFFA2A2A7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: actionText,
                style: TextStyle(
                  color: const Color(0xFF0066FF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
