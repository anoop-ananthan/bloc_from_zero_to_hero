import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_state.dart';

enum ConnectionType {
  wifi,
  mobile,
}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity;
  late StreamSubscription _subscription;

  InternetCubit({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(InternetLoading()) {
    monitorInternetConnection();
  }

  void monitorInternetConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi) {
        emit(const InternetConnected(ConnectionType.wifi));
      } else if (event == ConnectivityResult.mobile) {
        emit(const InternetConnected(ConnectionType.mobile));
      } else if (event == ConnectivityResult.none) {
        emit(InternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
