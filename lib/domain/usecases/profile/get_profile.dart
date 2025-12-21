import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/contact_profile.dart';
import '../../repositories/profile_repository.dart';

/// 프로필 가져오기 UseCase
class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, ContactProfile>> call(String profileId) async {
    return await repository.getProfile(profileId);
  }
}

