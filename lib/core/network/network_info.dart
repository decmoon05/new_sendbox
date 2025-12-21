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
    final result = await _connectivity.checkConnectivity();
    // connectivity_plus 5.0.2 returns List<ConnectivityResult>
    final results = result as List<ConnectivityResult>;
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final result = await _connectivity.checkConnectivity();
    // connectivity_plus 5.0.2 returns List<ConnectivityResult>
    final results = result as List<ConnectivityResult>;
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return ConnectivityResult.none;
    }
    // 첫 번째 none이 아닌 결과 반환
    return results.firstWhere(
      (r) => r != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      final resultList = results as List<ConnectivityResult>;
      if (resultList.isEmpty || resultList.every((r) => r == ConnectivityResult.none)) {
        return ConnectivityResult.none;
      }
      return resultList.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    });
  }
}
