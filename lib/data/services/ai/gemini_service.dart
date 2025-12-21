import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/ai_recommendation.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/contact_profile.dart';

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
    final conversationHistory = conversation.messages
        .takeLast(10)
        .map((m) => '${m.type == MessageType.sent ? "나" : profile.name}: ${m.content}')
        .join('\n');

    return '''
You are an AI assistant helping users write personalized messages in Korean.

Context:
- Contact Name: ${profile.name}
- Relationship: ${profile.aiAnalysis?.relationship ?? "unknown"}
- Conversation History:
$conversationHistory
- Message Context: $messageContext

Task: Generate 3-5 message recommendations that are:
- Appropriate for the relationship
- Match the conversation tone
- Natural and authentic in Korean
- Respectful and considerate

Return the recommendations as a JSON array:
[
  {
    "message": "message text in Korean",
    "tone": "formal|casual|friendly",
    "reason": "brief explanation"
  }
]
''';
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
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(content);
      if (jsonMatch == null) {
        throw Exception('Invalid response format');
      }
      
      final jsonString = jsonMatch.group(0)!;
      final recommendationsData = (jsonString as dynamic) as List; // TODO: 실제 JSON 파싱
      
      final recommendations = <MessageOption>[];
      for (int i = 0; i < recommendationsData.length; i++) {
        final data = recommendationsData[i] as Map<String, dynamic>;
        recommendations.add(
          MessageOption(
            id: 'option_$i',
            message: data['message'] as String,
            tone: data['tone'] as String,
            reason: data['reason'] as String,
            confidence: 80,
          ),
        );
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

