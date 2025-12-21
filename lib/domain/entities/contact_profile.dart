import 'package:equatable/equatable.dart';

/// 연락처 프로필 엔티티
class ContactProfile extends Equatable {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? photoUrl;
  final List<PlatformIdentifier> platforms;
  final ProfileAnalysis? aiAnalysis;
  final List<String> tags;
  final String? notes;
  final int priority; // 1-5
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContactProfile({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.photoUrl,
    this.platforms = const [],
    this.aiAnalysis,
    this.tags = const [],
    this.notes,
    this.priority = 3,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        photoUrl,
        platforms,
        aiAnalysis,
        tags,
        notes,
        priority,
        createdAt,
        updatedAt,
      ];
}

/// 플랫폼 식별자
class PlatformIdentifier extends Equatable {
  final String platform; // sms, kakao, discord, etc.
  final String identifier;
  final DateTime? lastMessageAt;
  final int messageCount;

  const PlatformIdentifier({
    required this.platform,
    required this.identifier,
    this.lastMessageAt,
    this.messageCount = 0,
  });

  @override
  List<Object?> get props => [
        platform,
        identifier,
        lastMessageAt,
        messageCount,
      ];
}

/// 프로필 AI 분석 결과
class ProfileAnalysis extends Equatable {
  final String tone; // formal, casual, friendly
  final List<String> interests;
  final String relationship; // friend, family, colleague, etc.
  final String communicationStyle; // brief, detailed, emojis
  final List<String> topics;
  final String sentiment; // positive, neutral, negative
  final DateTime analyzedAt;

  const ProfileAnalysis({
    required this.tone,
    required this.interests,
    required this.relationship,
    required this.communicationStyle,
    required this.topics,
    required this.sentiment,
    required this.analyzedAt,
  });

  @override
  List<Object?> get props => [
        tone,
        interests,
        relationship,
        communicationStyle,
        topics,
        sentiment,
        analyzedAt,
      ];
}

