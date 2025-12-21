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
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final result = await _connectivity.checkConnectivity();
    return result.first;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}

