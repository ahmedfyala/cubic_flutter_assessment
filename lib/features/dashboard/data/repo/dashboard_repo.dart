import '../models/account_model.dart';
import '../models/transaction_model.dart';

abstract class DashboardRepo {
  Future<AccountModel> getAccountData(String userName);
  Future<List<TransactionModel>> getRecentTransactions();
}
