import 'package:isar/isar.dart';
import '../../domain/entities/contact_profile.dart';

part 'contact_profile_model.g.dart';

/// Isar 데이터베이스용 ContactProfile 모델
@collection
class ContactProfileModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String profileId;

  late String name;
  late String? phoneNumber;
  late String? email;
  late String? photoUrl;

  // 플랫폼 정보는 JSON으로 저장
  late String? platformsJson;

  // AI 분석 결과는 JSON으로 저장
  late String? aiAnalysisJson;

  late String? tagsJson;
  late String? notes;
  late int priority; // 1-5

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  /// Entity로 변환
  ContactProfile toEntity() {
    return ContactProfile(
      id: profileId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      photoUrl: photoUrl,
      platforms: platformsJson != null
          ? _parsePlatforms(platformsJson!)
          : const [],
      aiAnalysis: aiAnalysisJson != null
          ? _parseAiAnalysis(aiAnalysisJson!)
          : null,
      tags: tagsJson != null ? _parseTags(tagsJson!) : const [],
      notes: notes,
      priority: priority,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Entity에서 생성
  factory ContactProfileModel.fromEntity(ContactProfile profile) {
    return ContactProfileModel()
      ..profileId = profile.id
      ..name = profile.name
      ..phoneNumber = profile.phoneNumber
      ..email = profile.email
      ..photoUrl = profile.photoUrl
      ..platformsJson = profile.platforms.isNotEmpty
          ? _encodePlatforms(profile.platforms)
          : null
      ..aiAnalysisJson =
          profile.aiAnalysis != null ? _encodeAiAnalysis(profile.aiAnalysis!) : null
      ..tagsJson = profile.tags.isNotEmpty ? _encodeTags(profile.tags) : null
      ..notes = profile.notes
      ..priority = profile.priority
      ..createdAt = profile.createdAt
      ..updatedAt = profile.updatedAt;
  }

  // JSON 파싱 헬퍼 (향후 실제 JSON 직렬화 라이브러리 사용)
  List<PlatformIdentifier> _parsePlatforms(String json) {
    // TODO: 실제 JSON 파싱 구현
    return [];
  }

  ProfileAnalysis? _parseAiAnalysis(String json) {
    // TODO: 실제 JSON 파싱 구현
    return null;
  }

  List<String> _parseTags(String json) {
    // TODO: 실제 JSON 파싱 구현
    return [];
  }

  String _encodePlatforms(List<PlatformIdentifier> platforms) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }

  String _encodeAiAnalysis(ProfileAnalysis analysis) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }

  String _encodeTags(List<String> tags) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }
}

