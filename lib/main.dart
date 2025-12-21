import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'core/init/app_init.dart';
import 'core/theme/app_theme.dart';
import 'core/di/providers.dart';
import 'data/services/storage/isar_storage.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/routes/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱 초기화
  await AppInit.initialize();
  
  // Isar 인스턴스 가져오기 (이미 초기화됨)
  final isar = await IsarStorage.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWith((ref) => isar),
      ],
      child: const SendBoxApp(),
    ),
  );
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


