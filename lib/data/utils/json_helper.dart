import 'dart:convert';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/contact_profile.dart';
import '../../../domain/entities/ai_recommendation.dart';

/// JSON 직렬화/역직렬화 헬퍼
class JsonHelper {
  JsonHelper._();

  /// Attachment 리스트를 JSON 문자열로 변환
  static String encodeAttachments(List<Attachment> attachments) {
    final list = attachments.map((a) => {
      'id': a.id,
      'type': a.type,
      'url': a.url,
      'thumbnailUrl': a.thumbnailUrl,
      'size': a.size,
      'mimeType': a.mimeType,
    }).toList();
    return jsonEncode(list);
  }

  /// JSON 문자열을 Attachment 리스트로 변환
  static List<Attachment> decodeAttachments(String jsonString) {
    try {
      final list = jsonDecode(jsonString) as List;
      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return Attachment(
          id: map['id'] as String,
          type: map['type'] as String,
          url: map['url'] as String,
          thumbnailUrl: map['thumbnailUrl'] as String?,
          size: map['size'] as int?,
          mimeType: map['mimeType'] as String?,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Map을 JSON 문자열로 변환
  static String encodeMetadata(Map<String, dynamic> metadata) {
    return jsonEncode(metadata);
  }

  /// JSON 문자열을 Map으로 변환
  static Map<String, dynamic> decodeMetadata(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// PlatformIdentifier 리스트를 JSON 문자열로 변환
  static String encodePlatforms(List<PlatformIdentifier> platforms) {
    final list = platforms.map((p) => {
      'platform': p.platform,
      'identifier': p.identifier,
      'lastMessageAt': p.lastMessageAt?.toIso8601String(),
      'messageCount': p.messageCount,
    }).toList();
    return jsonEncode(list);
  }

  /// JSON 문자열을 PlatformIdentifier 리스트로 변환
  static List<PlatformIdentifier> decodePlatforms(String jsonString) {
    try {
      final list = jsonDecode(jsonString) as List;
      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return PlatformIdentifier(
          platform: map['platform'] as String,
          identifier: map['identifier'] as String,
          lastMessageAt: map['lastMessageAt'] != null
              ? DateTime.parse(map['lastMessageAt'] as String)
              : null,
          messageCount: map['messageCount'] as int? ?? 0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// ProfileAnalysis를 JSON 문자열로 변환
  static String encodeProfileAnalysis(ProfileAnalysis analysis) {
    final map = {
      'tone': analysis.tone,
      'interests': analysis.interests,
      'relationship': analysis.relationship,
      'communicationStyle': analysis.communicationStyle,
      'topics': analysis.topics,
      'sentiment': analysis.sentiment,
      'analyzedAt': analysis.analyzedAt.toIso8601String(),
    };
    return jsonEncode(map);
  }

  /// JSON 문자열을 ProfileAnalysis로 변환
  static ProfileAnalysis? decodeProfileAnalysis(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProfileAnalysis(
        tone: map['tone'] as String,
        interests: List<String>.from(map['interests'] as List),
        relationship: map['relationship'] as String,
        communicationStyle: map['communicationStyle'] as String,
        topics: List<String>.from(map['topics'] as List),
        sentiment: map['sentiment'] as String,
        analyzedAt: DateTime.parse(map['analyzedAt'] as String),
      );
    } catch (e) {
      return null;
    }
  }

  /// String 리스트를 JSON 문자열로 변환
  static String encodeStringList(List<String> list) {
    return jsonEncode(list);
  }

  /// JSON 문자열을 String 리스트로 변환
  static List<String> decodeStringList(String jsonString) {
    try {
      return List<String>.from(jsonDecode(jsonString) as List);
    } catch (e) {
      return [];
    }
  }

  /// MessageOption 리스트를 JSON 문자열로 변환
  static String encodeMessageOptions(List<MessageOption> options) {
    final list = options.map((o) => {
      'id': o.id,
      'message': o.message,
      'tone': o.tone,
      'reason': o.reason,
      'confidence': o.confidence,
    }).toList();
    return jsonEncode(list);
  }

  /// JSON 문자열을 MessageOption 리스트로 변환
  static List<MessageOption> decodeMessageOptions(String jsonString) {
    try {
      final list = jsonDecode(jsonString) as List;
      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return MessageOption(
          id: map['id'] as String,
          message: map['message'] as String,
          tone: map['tone'] as String,
          reason: map['reason'] as String,
          confidence: map['confidence'] as int? ?? 0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

