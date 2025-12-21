import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_sendbox/presentation/shared/widgets/error_widget.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('should display error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget.simple(
              message: 'Test error message',
            ),
          ),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should display network error widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget.network(),
          ),
        ),
      );

      expect(find.text('연결 오류'), findsOneWidget);
      expect(find.text('인터넷 연결 상태를 확인하고 다시 시도해주세요'), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided', (WidgetTester tester) async {
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget.simple(
              message: 'Error',
              onRetry: () {
                retryCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('다시 시도'), findsOneWidget);

      await tester.tap(find.text('다시 시도'));
      await tester.pump();

      expect(retryCalled, true);
    });
  });

  group('EmptyStateWidget', () {
    testWidgets('should display empty state message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget.noConversations(),
          ),
        ),
      );

      expect(find.text('대화가 없습니다'), findsOneWidget);
      expect(find.text('새로운 대화를 시작해보세요'), findsOneWidget);
    });

    testWidgets('should display custom empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'No items',
              description: 'Add some items',
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Add some items'), findsOneWidget);
    });
  });
}

