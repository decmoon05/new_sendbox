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
      // connectivity_plus 5.0.2 returns Future<List<ConnectivityResult>>
      // but actually returns single ConnectivityResult at runtime
      if (result is List<ConnectivityResult>) {
        return result.any((r) => r != ConnectivityResult.none);
      }
      // Single ConnectivityResult
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
      // connectivity_plus 5.0.2 returns Future<List<ConnectivityResult>>
      // but actually returns single ConnectivityResult at runtime
      if (result is List<ConnectivityResult>) {
        if (result.isEmpty || result.every((r) => r == ConnectivityResult.none)) {
          return ConnectivityResult.none;
        }
        return result.firstWhere(
          (r) => r != ConnectivityResult.none,
          orElse: () => ConnectivityResult.none,
        );
      }
      // Single ConnectivityResult
      return result as ConnectivityResult;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      // connectivity_plus 5.0.2 onConnectivityChanged returns Stream<List<ConnectivityResult>>
      // but actually returns single ConnectivityResult at runtime
      if (result is List<ConnectivityResult>) {
        if (result.isEmpty || result.every((r) => r == ConnectivityResult.none)) {
          return ConnectivityResult.none;
        }
        return result.firstWhere(
          (r) => r != ConnectivityResult.none,
          orElse: () => ConnectivityResult.none,
        );
      }
      // Single ConnectivityResult
      return result as ConnectivityResult;
    });
  }
}
