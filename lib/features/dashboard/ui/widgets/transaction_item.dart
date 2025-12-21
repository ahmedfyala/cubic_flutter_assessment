import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            transaction.isIncome ? Icons.south_west : Icons.apple,
            color: colorScheme.onSurface,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                transaction.category,
                style: TextStyle(color: colorScheme.outline, fontSize: 12.sp),
              ),
            ],
          ),
        ),
        Text(
          "${transaction.isIncome ? '+' : '-'} \$${transaction.amount}",
          style: TextStyle(
            color: transaction.isIncome ? Colors.blue : colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
