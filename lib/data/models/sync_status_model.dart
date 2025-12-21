import 'package:isar/isar.dart';
import '../../domain/entities/sync_status.dart';

part 'sync_status_model.g.dart';

/// Isar 데이터베이스용 SyncStatus 모델
@collection
class SyncStatusModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String statusId;

  late String type; // "conversation", "profile", "callRecord"
  late String entityId;
  late String state; // "pending", "syncing", "synced", "error"

  late DateTime? lastSyncedAt;
  late String? errorMessage;
  late int retryCount;

  @Index()
  late DateTime createdAt;

  /// 기본 생성자 (Isar 필수)
  SyncStatusModel();

  /// Entity로 변환
  SyncStatus toEntity() {
    return SyncStatus(
      id: statusId,
      type: _parseType(type),
      entityId: entityId,
      state: _parseState(state),
      lastSyncedAt: lastSyncedAt,
      errorMessage: errorMessage,
      retryCount: retryCount,
    );
  }

  /// Entity에서 생성
  static SyncStatusModel fromEntity(SyncStatus status) {
    final model = SyncStatusModel();
    model.statusId = status.id;
    model.type = _encodeTypeStatic(status.type);
    model.entityId = status.entityId;
    model.state = _encodeStateStatic(status.state);
    model.lastSyncedAt = status.lastSyncedAt;
    model.errorMessage = status.errorMessage;
    model.retryCount = status.retryCount;
    model.createdAt = DateTime.now();
    return model;
  }

  SyncType _parseType(String type) {
    switch (type) {
      case 'profile':
        return SyncType.profile;
      case 'callRecord':
        return SyncType.callRecord;
      default:
        return SyncType.conversation;
    }
  }

  SyncState _parseState(String state) {
    switch (state) {
      case 'syncing':
        return SyncState.syncing;
      case 'synced':
        return SyncState.synced;
      case 'error':
        return SyncState.error;
      default:
        return SyncState.pending;
    }
  }

  static String _encodeTypeStatic(SyncType type) {
    switch (type) {
      case SyncType.profile:
        return 'profile';
      case SyncType.callRecord:
        return 'callRecord';
      default:
        return 'conversation';
    }
  }

  static String _encodeStateStatic(SyncState state) {
    switch (state) {
      case SyncState.syncing:
        return 'syncing';
      case SyncState.synced:
        return 'synced';
      case SyncState.error:
        return 'error';
      default:
        return 'pending';
    }
  }
}

