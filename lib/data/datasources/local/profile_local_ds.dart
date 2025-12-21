import 'package:isar/isar.dart';
import '../../models/contact_profile_model.dart';
import '../../../domain/entities/contact_profile.dart';
import '../../../core/errors/exceptions.dart';

/// 로컬 프로필 데이터소스
abstract class ProfileLocalDataSource {
  Future<List<ContactProfile>> getProfiles();
  Future<ContactProfile?> getProfile(String id);
  Future<void> saveProfile(ContactProfile profile);
  Future<void> deleteProfile(String id);
}

/// Isar를 사용한 프로필 로컬 데이터소스 구현
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Isar isar;

  ProfileLocalDataSourceImpl(this.isar);

  @override
  Future<List<ContactProfile>> getProfiles() async {
    try {
      final profileModels = await isar.contactProfileModels
          .where()
          .sortByUpdatedAtDesc()
          .findAll();

      return profileModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw CacheException(
        message: '프로필 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<ContactProfile?> getProfile(String id) async {
    try {
      final profileModel = await isar.contactProfileModels
          .filter()
          .profileIdEqualTo(id)
          .findFirst();

      return profileModel?.toEntity();
    } catch (e) {
      throw CacheException(
        message: '프로필을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveProfile(ContactProfile profile) async {
    try {
      await isar.writeTxn(() async {
        final existing = await isar.contactProfileModels
            .filter()
            .profileIdEqualTo(profile.id)
            .findFirst();

        final profileModel = ContactProfileModel.fromEntity(profile);
        if (existing != null) {
          profileModel.id = existing.id;
          profileModel.createdAt = existing.createdAt;
        }

        await isar.contactProfileModels.put(profileModel);
      });
    } catch (e) {
      throw CacheException(
        message: '프로필을 저장하는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    try {
      await isar.contactProfileModels
          .filter()
          .profileIdEqualTo(id)
          .deleteFirst();
    } catch (e) {
      throw CacheException(
        message: '프로필을 삭제하는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

