import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/app_colors.dart';

enum SnackBarType { error, success, loading, internetConnection }

enum NotificationType { toast, snackbar }

class Notifier {
  static void show({
    required BuildContext context,
    required String message,
    NotificationType type = NotificationType.snackbar,
    SnackBarType? snackBarType,
    Color? bgColor,
    Color? textColor,
  }) {
    if (type == NotificationType.toast) {
      CustomToast.showToast(
        message,
        bgColor: bgColor ?? AppColors.primary,
        textColor: textColor ?? Colors.white,
      );
    } else {
      CustomSnackBar.show(
        context: context,
        type: snackBarType ?? SnackBarType.error,
        message: message,
      );
    }
  }
}

class CustomToast {
  static void showToast(
    String message, {
    Color bgColor = Colors.green,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}

class SnackBarConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final Duration duration;

  const SnackBarConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    this.duration = const Duration(milliseconds: 4000),
  });

  factory SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return const SnackBarConfig(
          backgroundColor: Color(0xFF96132C),
          iconColor: Colors.white,
          icon: Icons.error_outline,
          title: 'Error',
        );
      case SnackBarType.success:
        return const SnackBarConfig(
          backgroundColor: Color(0xFF184E44),
          iconColor: Colors.white,
          icon: Icons.check_circle_outline,
          title: 'Successful',
        );
      case SnackBarType.loading:
        return const SnackBarConfig(
          backgroundColor: AppColors.primary,
          iconColor: Colors.white,
          icon: Icons.hourglass_empty,
          title: 'Loading',
        );
      case SnackBarType.internetConnection:
        return const SnackBarConfig(
          backgroundColor: Colors.black,
          iconColor: Colors.red,
          icon: Icons.wifi_off_rounded,
          title: 'Alert',
        );
    }
  }
}

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required SnackBarType type,
    required String message,
  }) {
    final config = SnackBarConfig.fromType(type);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: config.duration,
        backgroundColor: config.backgroundColor,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Icon(config.icon, size: 24, color: config.iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    config.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
