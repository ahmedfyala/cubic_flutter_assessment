import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/account_model.dart';

class AccountSummaryCard extends StatelessWidget {
  final AccountModel account;
  const AccountSummaryCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          LocaleKeys.current_balance.tr(),
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "\$${account.balance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
