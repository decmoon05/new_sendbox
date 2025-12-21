import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';

import '../network/network_info.dart';
import '../network/api_client.dart';
import '../../data/services/storage/isar_storage.dart';
import '../../data/datasources/local/conversation_local_ds.dart';
import '../../data/datasources/local/profile_local_ds.dart';
import '../../data/datasources/remote/firebase_datasource.dart';
import '../../data/repositories/conversation_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/services/ai/gemini_service.dart';
import '../../data/services/platform/sms/sms_service.dart';
import '../../data/services/platform/sms/sms_platform_adapter.dart';
import '../../data/services/platform/sms/sms_listener_service.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/ai_repository.dart';

/// 네트워크 정보 Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = Connectivity();
  return NetworkInfoImpl(connectivity);
});

/// Isar 데이터베이스 Provider
/// main.dart에서 초기화된 Isar 인스턴스를 여기에 저장
final isarProvider = StateProvider<Isar?>((ref) => null);

/// Firebase Firestore Provider
/// Firebase가 초기화되지 않은 경우 예외를 발생시키지 않고 안전하게 처리
final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  try {
    if (Firebase.apps.isEmpty) {
      return null;
    }
    return FirebaseFirestore.instance;
  } catch (e) {
    return null;
  }
});

/// Firebase Auth Provider
/// Firebase가 초기화되지 않은 경우 예외를 발생시키지 않고 안전하게 처리
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  try {
    if (Firebase.apps.isEmpty) {
      return null;
    }
    return FirebaseAuth.instance;
  } catch (e) {
    return null;
  }
});

/// 현재 사용자 ID Provider
final currentUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) {
    return null;
  }
  return auth.currentUser?.uid;
});

/// API 클라이언트 Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Dio Provider (Gemini API용)
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

/// 로컬 대화 데이터소스 Provider
final conversationLocalDataSourceProvider = Provider<ConversationLocalDataSource>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    throw Exception('Isar가 초기화되지 않았습니다.');
  }
  return ConversationLocalDataSourceImpl(isar);
});

/// 로컬 프로필 데이터소스 Provider
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    throw Exception('Isar가 초기화되지 않았습니다.');
  }
  return ProfileLocalDataSourceImpl(isar);
});

/// Firebase 원격 데이터소스 Provider
final firebaseDataSourceProvider = Provider<FirebaseDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final userId = ref.watch(currentUserIdProvider) ?? '';
  return FirebaseDataSourceImpl(
    firestore: firestore,
    userId: userId,
  );
});

/// 대화 리포지토리 Provider
final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  final localDataSource = ref.watch(conversationLocalDataSourceProvider);
  final remoteDataSource = ref.watch(firebaseDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ConversationRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// 프로필 리포지토리 Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.watch(profileLocalDataSourceProvider);
  final remoteDataSource = ref.watch(firebaseDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ProfileRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// Gemini AI 서비스 Provider
/// API 키가 없어도 앱이 실행되도록 nullable로 처리
final geminiServiceProvider = Provider<GeminiService?>((ref) {
  final dio = ref.watch(dioProvider);
  const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  if (apiKey.isEmpty) {
    // API 키가 없으면 null 반환 (앱은 계속 실행되지만 AI 기능 사용 불가)
    return null;
  }
  return GeminiService(dio: dio, apiKey: apiKey);
});

/// AI 리포지토리 Provider
final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  // geminiService가 null일 수 있으므로 null 체크
  if (geminiService == null) {
    // API 키가 없으면 기본 구현체 반환 (에러 처리 포함)
    return AIRepositoryImpl(geminiService: null);
  }
  return AIRepositoryImpl(geminiService: geminiService);
});
