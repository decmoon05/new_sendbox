import 'package:dartz/dartz.dart';
import '../../domain/entities/contact_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/profile_local_ds.dart';
import '../datasources/remote/firebase_datasource.dart';

/// 프로필 리포지토리 구현
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final FirebaseDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ContactProfile>>> getProfiles() async {
    try {
      if (await networkInfo.isConnected) {
        // 온라인: 원격에서 가져오고 로컬에 저장
        try {
          final profiles = await remoteDataSource.getProfiles();
          
          // 로컬에 저장 (백그라운드)
          for (final profile in profiles) {
            localDataSource.saveProfile(profile).catchError((_) {});
          }
          
          return Right(profiles);
        } catch (e) {
          // 원격 실패 시 로컬에서 가져오기
          final localProfiles = await localDataSource.getProfiles();
          return Right(localProfiles);
        }
      } else {
        // 오프라인: 로컬에서만 가져오기
        final profiles = await localDataSource.getProfiles();
        return Right(profiles);
      }
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } on ServerException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('예상치 못한 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ContactProfile>> getProfile(String id) async {
    try {
      final profile = await localDataSource.getProfile(id);
      
      if (profile == null) {
        return Left(CacheFailure('프로필을 찾을 수 없습니다.'));
      }
      
      // 온라인인 경우 원격에서 최신 데이터 가져오기 (백그라운드)
      if (await networkInfo.isConnected) {
        remoteDataSource.getProfiles().then((profiles) {
          final updated = profiles.firstWhere(
            (p) => p.id == id,
            orElse: () => profile,
          );
          localDataSource.saveProfile(updated).catchError((_) {});
        }).catchError((_) {});
      }
      
      return Right(profile);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('프로필을 가져오는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ContactProfile profile) async {
    try {
      await localDataSource.saveProfile(profile);
      
      // 온라인인 경우 원격에도 저장 (백그라운드)
      if (await networkInfo.isConnected) {
        remoteDataSource.syncProfile(profile).catchError((_) {});
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } on ServerException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('프로필을 저장하는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ContactProfile profile) async {
    // saveProfile과 동일하게 처리 (내부적으로 업데이트/생성 구분)
    return saveProfile(profile);
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String id) async {
    try {
      await localDataSource.deleteProfile(id);
      
      // 온라인인 경우 원격에서도 삭제 (백그라운드)
      if (await networkInfo.isConnected) {
        // TODO: 원격 삭제 구현
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('프로필을 삭제하는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ContactProfile>>> searchProfiles(String query) async {
    try {
      final profiles = await localDataSource.getProfiles();
      
      final filtered = profiles.where((profile) {
        return profile.name.toLowerCase().contains(query.toLowerCase()) ||
               profile.phoneNumber?.contains(query) == true ||
               profile.email?.toLowerCase().contains(query.toLowerCase()) == true;
      }).toList();
      
      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure('프로필 검색에 실패했습니다: ${e.toString()}'));
    }
  }
}

