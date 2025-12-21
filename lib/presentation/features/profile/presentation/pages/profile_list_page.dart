import 'package:flutter/material.dart';

/// 프로필 목록 페이지
class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연락처'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              '연락처 목록',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              '프로필 기능은 곧 추가됩니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

