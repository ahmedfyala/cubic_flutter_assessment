import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/account_model.dart';

class CreditCardWidget extends StatelessWidget {
  final AccountModel account;
  const CreditCardWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: const DecorationImage(
          image: AssetImage(AppAssets.cardBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 3),
            Text(
              account.accountNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
            const Spacer(),
            Text(
              account.cardHolderName.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _buildCardInfo(LocaleKeys.expiry_date.tr(), account.expiryDate),
                SizedBox(width: 40.w),
                _buildCardInfo(LocaleKeys.cvv.tr(), account.cvv),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
