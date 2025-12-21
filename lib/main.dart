import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'core/init/app_init.dart';
import 'core/theme/app_theme.dart';
import 'core/di/providers.dart';
import 'data/services/storage/isar_storage.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/routes/route_names.dart';
import 'core/utils/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱 초기화
  await AppInit.initialize();
  
  // Isar 인스턴스 가져오기 (이미 초기화됨)
  final isar = await IsarStorage.getInstance();
  
  final container = ProviderContainer(
    overrides: [
      isarProvider.overrideWithValue(isar),
    ],
  );

  // 샘플 데이터 시딩 (비동기로 실행, 앱 시작을 막지 않음)
  _seedSampleData(container);
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SendBoxApp(),
    ),
  );
}

/// 샘플 데이터 시딩
void _seedSampleData(ProviderContainer container) {
  // 비동기로 실행하되 앱 시작을 막지 않음
  Future.microtask(() async {
    try {
      final conversationRepository = container.read(conversationRepositoryProvider);
      final profileRepository = container.read(profileRepositoryProvider);
      
      await DataSeeder.seedIfEmpty(
        conversationRepository: conversationRepository,
        profileRepository: profileRepository,
      );
    } catch (e) {
      debugPrint('샘플 데이터 시딩 실패: $e');
    }
  });
}

class SendBoxApp extends StatelessWidget {
  const SendBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SendBox',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}


