import 'package:flutter/material.dart';

/// 채팅 목록 페이지
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SendBox'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              '채팅 목록',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              '채팅 기능은 곧 추가됩니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

