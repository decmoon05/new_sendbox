import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/contact_profile.dart';
import '../../../domain/entities/message.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/api_constants.dart';

/// Firebase 원격 데이터소스
abstract class FirebaseDataSource {
  Future<void> syncConversation(Conversation conversation);
  Future<List<Conversation>> getConversations();
  Future<void> syncProfile(ContactProfile profile);
  Future<List<ContactProfile>> getProfiles();
}

/// Firebase Firestore 데이터소스 구현
/// Firebase가 초기화되지 않은 경우 모든 메서드가 예외를 발생시키지 않고 빈 결과를 반환
class FirebaseDataSourceImpl implements FirebaseDataSource {
  final FirebaseFirestore? firestore;
  final String userId;

  FirebaseDataSourceImpl({
    required this.firestore,
    required this.userId,
  });

  /// Firebase가 사용 가능한지 확인
  bool get isAvailable => firestore != null;

  @override
  Future<void> syncConversation(Conversation conversation) async {
    if (!isAvailable) {
      // Firebase가 없으면 동기화 건너뛰기 (오프라인 모드)
      return;
    }

    try {
      final conversationRef = firestore!
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionConversations)
          .doc(conversation.id);

      await conversationRef.set({
        'id': conversation.id,
        'contactId': conversation.contactId,
        'platform': conversation.platform,
        'messages': conversation.messages.map((m) => _messageToJson(m)).toList(),
        'lastMessageAt': Timestamp.fromDate(conversation.lastMessageAt),
        'unreadCount': conversation.unreadCount,
        'isPinned': conversation.isPinned,
        'syncedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException(
        message: '대화 동기화에 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Conversation>> getConversations() async {
    if (!isAvailable) {
      // Firebase가 없으면 빈 리스트 반환 (로컬에서 가져오기)
      return [];
    }

    try {
      final conversationsSnapshot = await firestore!
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionConversations)
          .orderBy('lastMessageAt', descending: true)
          .get();

      final conversations = <Conversation>[];
      for (final doc in conversationsSnapshot.docs) {
        final data = doc.data();
        // TODO: 데이터를 Conversation 엔티티로 변환
        // 현재는 빈 리스트 반환 (구현 필요)
      }

      return conversations;
    } catch (e) {
      throw ServerException(
        message: '대화 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> syncProfile(ContactProfile profile) async {
    if (!isAvailable) {
      // Firebase가 없으면 동기화 건너뛰기 (오프라인 모드)
      return;
    }

    try {
      final profileRef = firestore!
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionProfiles)
          .doc(profile.id);

      await profileRef.set({
        'id': profile.id,
        'name': profile.name,
        'phoneNumber': profile.phoneNumber,
        'email': profile.email,
        'photoUrl': profile.photoUrl,
        'syncedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException(
        message: '프로필 동기화에 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ContactProfile>> getProfiles() async {
    if (!isAvailable) {
      // Firebase가 없으면 빈 리스트 반환 (로컬에서 가져오기)
      return [];
    }

    try {
      final profilesSnapshot = await firestore!
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionProfiles)
          .get();

      final profiles = <ContactProfile>[];
      for (final doc in profilesSnapshot.docs) {
        final data = doc.data();
        // TODO: 데이터를 ContactProfile 엔티티로 변환
        // 현재는 빈 리스트 반환 (구현 필요)
      }

      return profiles;
    } catch (e) {
      throw ServerException(
        message: '프로필 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Map<String, dynamic> _messageToJson(Message message) {
    return {
      'id': message.id,
      'conversationId': message.conversationId,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'content': message.content,
      'type': message.type == MessageType.sent ? 'sent' : 'received',
      'timestamp': Timestamp.fromDate(message.timestamp),
      'isRead': message.isRead,
    };
  }
}
