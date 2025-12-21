import 'package:dartz/dartz.dart';
import '../entities/sync_status.dart';
import '../../core/errors/failures.dart';

/// 동기화 리포지토리 인터페이스
abstract class SyncRepository {
  /// 클라우드로 동기화
  Future<Either<Failure, void>> syncToCloud();

  /// 클라우드에서 동기화
  Future<Either<Failure, void>> syncFromCloud();

  /// 동기화 상태 가져오기
  Future<Either<Failure, List<SyncStatus>>> getSyncStatus();

  /// 특정 엔티티 동기화 상태 가져오기
  Future<Either<Failure, SyncStatus>> getSyncStatusForEntity(
    String entityId,
  );
}

