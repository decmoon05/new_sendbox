import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 네트워크 연결 상태 확인 인터페이스
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<ConnectivityResult> get connectivityResult;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

/// 네트워크 연결 상태 구현
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      // connectivity_plus 5.0.2 returns Future<ConnectivityResult> (single value)
      return result != ConnectivityResult.none;
    } catch (e) {
      // 에러 발생 시 연결 안됨으로 간주
      return false;
    }
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    try {
      final result = await _connectivity.checkConnectivity();
      // connectivity_plus 5.0.2 returns Future<ConnectivityResult> (single value)
      return result;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    // connectivity_plus 5.0.2 onConnectivityChanged returns Stream<ConnectivityResult> (single value)
    return _connectivity.onConnectivityChanged;
  }
}
