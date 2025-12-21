import 'package:dartz/dartz.dart';
import '../entities/contact_profile.dart';
import '../../core/errors/failures.dart';

/// 프로필 리포지토리 인터페이스
abstract class ProfileRepository {
  /// 모든 프로필 가져오기
  Future<Either<Failure, List<ContactProfile>>> getProfiles();

  /// 특정 프로필 가져오기
  Future<Either<Failure, ContactProfile>> getProfile(String id);

  /// 프로필 저장
  Future<Either<Failure, void>> saveProfile(ContactProfile profile);

  /// 프로필 업데이트
  Future<Either<Failure, void>> updateProfile(ContactProfile profile);

  /// 프로필 삭제
  Future<Either<Failure, void>> deleteProfile(String id);

  /// 프로필 검색
  Future<Either<Failure, List<ContactProfile>>> searchProfiles(
    String query,
  );
}

