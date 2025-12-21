import 'package:equatable/equatable.dart';

/// 동기화 타입
enum SyncType {
  conversation,
  profile,
  callRecord,
}

/// 동기화 상태
enum SyncState {
  pending,
  syncing,
  synced,
  error,
}

/// 동기화 상태 엔티티
class SyncStatus extends Equatable {
  final String id;
  final SyncType type;
  final String entityId;
  final SyncState state;
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final int retryCount;

  const SyncStatus({
    required this.id,
    required this.type,
    required this.entityId,
    required this.state,
    this.lastSyncedAt,
    this.errorMessage,
    this.retryCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        entityId,
        state,
        lastSyncedAt,
        errorMessage,
        retryCount,
      ];
}

