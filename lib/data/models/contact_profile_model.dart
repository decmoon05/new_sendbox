import 'package:isar/isar.dart';
import '../../domain/entities/contact_profile.dart';
import '../utils/json_helper.dart';

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

  /// 기본 생성자 (Isar 필수)
  ContactProfileModel();

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
  static ContactProfileModel fromEntity(ContactProfile profile) {
    final model = ContactProfileModel();
    model.profileId = profile.id;
    model.name = profile.name;
    model.phoneNumber = profile.phoneNumber;
    model.email = profile.email;
    model.photoUrl = profile.photoUrl;
    model.platformsJson = profile.platforms.isNotEmpty
        ? _encodePlatformsStatic(profile.platforms)
        : null;
    model.aiAnalysisJson =
        profile.aiAnalysis != null ? _encodeAiAnalysisStatic(profile.aiAnalysis!) : null;
    model.tagsJson = profile.tags.isNotEmpty ? _encodeTagsStatic(profile.tags) : null;
    model.notes = profile.notes;
    model.priority = profile.priority;
    model.createdAt = profile.createdAt;
    model.updatedAt = profile.updatedAt;
    return model;
  }

  // JSON 파싱 헬퍼
  List<PlatformIdentifier> _parsePlatforms(String json) {
    return JsonHelper.decodePlatforms(json);
  }

  ProfileAnalysis? _parseAiAnalysis(String json) {
    return JsonHelper.decodeProfileAnalysis(json);
  }

  List<String> _parseTags(String json) {
    return JsonHelper.decodeStringList(json);
  }

  static String _encodePlatformsStatic(List<PlatformIdentifier> platforms) {
    return JsonHelper.encodePlatforms(platforms);
  }

  static String _encodeAiAnalysisStatic(ProfileAnalysis analysis) {
    return JsonHelper.encodeProfileAnalysis(analysis);
  }

  static String _encodeTagsStatic(List<String> tags) {
    return JsonHelper.encodeStringList(tags);
  }
}

