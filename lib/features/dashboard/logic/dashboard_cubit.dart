import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/cache_service.dart';
import '../data/models/account_model.dart';
import '../data/models/transaction_model.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final FirebaseAuth _firebaseAuth;
  final CacheService _cacheService;

  DashboardCubit(this._firebaseAuth, this._cacheService)
    : super(DashboardInitial());

  void loadDashboardData() {
    emit(DashboardLoading());

    final user = _firebaseAuth.currentUser;
    final String userName =
        user?.displayName ?? user?.email?.split('@')[0] ?? "User";

    
    final String randomAccount = _generateRandomAccount();

    final mockAccount = AccountModel(
      accountNumber: randomAccount,
      balance: 12580.40,
      cardHolderName: userName.toUpperCase(),
      expiryDate: "12/28",
      cvv: "442",
    );

    final mockTransactions = [
      TransactionModel(
        title: "Apple Store",
        category: "Entertainment",
        amount: 5.99,
        isIncome: false,
        iconPath: "",
      ),
      TransactionModel(
        title: "Spotify",
        category: "Music",
        amount: 12.99,
        isIncome: false,
        iconPath: "",
      ),
      TransactionModel(
        title: "Salary Transfer",
        category: "Income",
        amount: 2500.00,
        isIncome: true,
        iconPath: "",
      ),
      TransactionModel(
        title: "Grocery Store",
        category: "Shopping",
        amount: 45.00,
        isIncome: false,
        iconPath: "",
      ),
    ];

    emit(DashboardSuccess(mockAccount, mockTransactions, userName));
  }

  String _generateRandomAccount() {
    final random = Random();
    String part1 = (random.nextInt(9000) + 1000).toString();
    String part2 = (random.nextInt(9000) + 1000).toString();
    String part3 = (random.nextInt(9000) + 1000).toString();
    String part4 = (random.nextInt(9000) + 1000).toString();
    return "$part1 $part2 $part3 $part4";
  }
}
