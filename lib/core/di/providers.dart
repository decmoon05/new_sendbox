import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/network_info.dart';
import '../network/api_client.dart';

/// 네트워크 정보 Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = Connectivity();
  return NetworkInfoImpl(connectivity);
});

/// API 클라이언트 Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

