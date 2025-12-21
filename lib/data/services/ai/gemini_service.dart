import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/ai_recommendation.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/contact_profile.dart';
import '../../../domain/entities/message.dart';

/// Google Gemini AI 서비스
class GeminiService {
  final Dio dio;
  final String apiKey;

  GeminiService({
    required this.dio,
    required this.apiKey,
  });

  /// 메시지 추천 가져오기
  Future<AIRecommendation> getMessageRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  }) async {
    try {
      final prompt = _buildMessagePrompt(
        conversation: conversation,
        profile: profile,
        messageContext: messageContext,
      );

      final response = await dio.post(
        '${ApiConstants.geminiBaseUrl}/models/${ApiConstants.geminiModel}:generateContent',
        queryParameters: {'key': apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        },
      );

      return _parseRecommendationResponse(response.data, messageContext, conversation.id);
    } on DioException catch (e) {
      throw ServerException(
        message: 'AI 추천을 가져오는데 실패했습니다: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw ServerException(
        message: '예상치 못한 오류: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// 프롬프트 생성
  String _buildMessagePrompt({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  }) {
    final recentMessages = conversation.messages.length > 10
        ? conversation.messages.sublist(conversation.messages.length - 10)
        : conversation.messages;
    final conversationHistory = recentMessages
        .map((m) => '${m.type == MessageType.sent ? "나" : profile.name}: ${m.content}')
        .join('\n');

    return '''You are an AI assistant helping users write personalized messages in Korean.

Context:
- Contact Name: ${profile.name}
- Relationship: ${profile.aiAnalysis?.relationship ?? "unknown"}
- Communication Style: ${profile.aiAnalysis?.communicationStyle ?? "normal"}
- Conversation History (최근 메시지):
$conversationHistory
- Message Context (사용자가 입력한 내용 또는 상황): $messageContext

Task: Generate 3-5 message recommendations in Korean that are:
- Appropriate for the relationship and communication style
- Match the conversation tone naturally
- Natural and authentic in Korean
- Respectful and considerate
- Contextually relevant

Important: Return ONLY a valid JSON array, no additional text or explanation.
Format:
[
  {
    "message": "한국어 메시지 내용",
    "tone": "formal|casual|friendly",
    "reason": "이 메시지를 추천하는 이유"
  }
]''';
  }

  /// 응답 파싱
  AIRecommendation _parseRecommendationResponse(
    Map<String, dynamic> response,
    String messageContext,
    String conversationId,
  ) {
    try {
      final candidates = response['candidates'] as List;
      final content = candidates.first['content']['parts'].first['text'] as String;
      
      // JSON 배열 추출 (마크다운 코드 블록 제거)
      var jsonString = content.trim();
      
      // 마크다운 코드 블록 제거
      jsonString = jsonString.replaceAll(RegExp(r'```json\n?'), '');
      jsonString = jsonString.replaceAll(RegExp(r'```\n?'), '');
      jsonString = jsonString.trim();
      
      // JSON 배열 부분만 추출 (대괄호로 시작하는 부분)
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(jsonString);
      if (jsonMatch != null) {
        jsonString = jsonMatch.group(0)!;
      }
      
      // JSON 파싱
      final recommendationsData = jsonDecode(jsonString) as List;
      
      final recommendations = <MessageOption>[];
      for (int i = 0; i < recommendationsData.length; i++) {
        final data = recommendationsData[i] as Map<String, dynamic>;
        recommendations.add(
          MessageOption(
            id: 'option_${DateTime.now().millisecondsSinceEpoch}_$i',
            message: data['message'] as String? ?? '',
            tone: data['tone'] as String? ?? 'casual',
            reason: data['reason'] as String? ?? '상황에 맞는 메시지',
            confidence: 80,
          ),
        );
      }
      
      if (recommendations.isEmpty) {
        throw Exception('추천 메시지가 생성되지 않았습니다.');
      }

      return AIRecommendation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        messageContext: messageContext,
        recommendations: recommendations,
        type: RecommendationType.message,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(
        message: 'AI 응답을 파싱하는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

