import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../logic/dashboard_cubit.dart';
import '../../logic/dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/transaction_item.dart';
import '../widgets/account_summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardSuccess) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    DashboardHeader(
                      userName: state.userName,
                      onLogoutTap: () async {
                        await context.read<AuthCubit>().logout();
                        if (context.mounted)
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.login,
                          );
                      },
                    ),
                    SizedBox(height: 40.h),
                    AccountSummaryCard(account: state.account),
                    SizedBox(height: 20.h),
                    CreditCardWidget(account: state.account),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteNames.branchesMap),
                      child: Text(LocaleKeys.find_branches.tr()),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.recent_transactions.tr(),
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          LocaleKeys.see_all.tr(),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.transactions.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) => TransactionItem(
                        transaction: state.transactions[index],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
