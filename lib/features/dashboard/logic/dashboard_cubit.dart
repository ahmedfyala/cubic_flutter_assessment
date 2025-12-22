import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repo/dashboard_repo.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final FirebaseAuth _firebaseAuth;
  final DashboardRepo _repo;

  DashboardCubit(this._firebaseAuth, this._repo) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final user = _firebaseAuth.currentUser;
      final String userName =
          user?.displayName ?? user?.email?.split('@')[0] ?? "User";

      final account = await _repo.getAccountData(userName);
      final transactions = await _repo.getRecentTransactions();

      emit(DashboardSuccess(account, transactions, userName));
    } catch (e) {
      
    }
  }
}
