import 'dart:math';
import 'package:injectable/injectable.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import 'dashboard_repo.dart';

@LazySingleton(as: DashboardRepo)
class DashboardRepoImpl implements DashboardRepo {
  @override
  Future<AccountModel> getAccountData(String userName) async {
    await Future.delayed(const Duration(seconds: 1)); 
    return AccountModel(
      accountNumber: _generateRandomAccount(),
      balance: 12580.40,
      cardHolderName: userName.toUpperCase(),
      expiryDate: "12/28",
      cvv: "442",
    );
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    return [
      TransactionModel(
        title: "Apple Store",
        category: "Entertainment",
        amount: 5.99,
        isIncome: false,
        iconPath: "",
      ),
      TransactionModel(
        title: "Salary Transfer",
        category: "Income",
        amount: 2500.0,
        isIncome: true,
        iconPath: "",
      ),
    ];
  }

  String _generateRandomAccount() {
    final random = Random();
    return "${random.nextInt(9000) + 1000} ${random.nextInt(9000) + 1000} ${random.nextInt(9000) + 1000} ${random.nextInt(9000) + 1000}";
  }
}
