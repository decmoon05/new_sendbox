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
    // connectivity_plus 5.0+ returns List<ConnectivityResult>
    if (result is List) {
      return result.any((r) => r != ConnectivityResult.none);
    }
    // Fallback for older versions
    return result != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final result = await _connectivity.checkConnectivity();
    // connectivity_plus 5.0+ returns List<ConnectivityResult>
    if (result is List<ConnectivityResult>) {
      if (result.isEmpty || result.every((r) => r == ConnectivityResult.none)) {
        return ConnectivityResult.none;
      }
      // 첫 번째 none이 아닌 결과 반환
      return result.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    }
    // Fallback for older versions
    return result as ConnectivityResult;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      if (results is List<ConnectivityResult>) {
        if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
          return ConnectivityResult.none;
        }
        return results.firstWhere(
          (r) => r != ConnectivityResult.none,
          orElse: () => ConnectivityResult.none,
        );
      }
      return results as ConnectivityResult;
    });
  }
}

