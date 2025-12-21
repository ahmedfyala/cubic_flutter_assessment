import '../data/models/account_model.dart';
import '../data/models/transaction_model.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {
  final AccountModel account;
  final List<TransactionModel> transactions;
  final String userName; 
  DashboardSuccess(this.account, this.transactions, this.userName);
}
