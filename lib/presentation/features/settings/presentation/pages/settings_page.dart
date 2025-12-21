import 'package:flutter/material.dart';

/// 설정 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              '설정',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              '설정 기능은 곧 추가됩니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

