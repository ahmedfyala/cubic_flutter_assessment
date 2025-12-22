import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/network_info.dart';

enum ConnectivityStatus { initial, connected, disconnected }

@injectable
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final NetworkInfo _networkInfo;
  StreamSubscription? _subscription;

  ConnectivityCubit(this._networkInfo) : super(ConnectivityStatus.initial) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = _networkInfo.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(ConnectivityStatus.disconnected);
      } else {
        if (state != ConnectivityStatus.initial) {
          emit(ConnectivityStatus.connected);
        }
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
