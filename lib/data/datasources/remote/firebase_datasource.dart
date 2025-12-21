import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/contact_profile.dart';
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
class FirebaseDataSourceImpl implements FirebaseDataSource {
  final FirebaseFirestore firestore;
  final String userId;

  FirebaseDataSourceImpl({
    required this.firestore,
    required this.userId,
  });

  @override
  Future<void> syncConversation(Conversation conversation) async {
    try {
      final conversationRef = firestore
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
    try {
      final snapshot = await firestore
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionConversations)
          .orderBy('lastMessageAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _conversationFromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException(
        message: '대화 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> syncProfile(ContactProfile profile) async {
    try {
      final profileRef = firestore
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
        'platforms': profile.platforms.map((p) => {
          'platform': p.platform,
          'identifier': p.identifier,
          'lastMessageAt': p.lastMessageAt?.toIso8601String(),
          'messageCount': p.messageCount,
        }).toList(),
        'tags': profile.tags,
        'notes': profile.notes,
        'priority': profile.priority,
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
    try {
      final snapshot = await firestore
          .collection(ApiConstants.firebaseCollectionUsers)
          .doc(userId)
          .collection(ApiConstants.firebaseCollectionProfiles)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => _profileFromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(
        message: '프로필 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  // JSON 변환 헬퍼 메서드들
  Map<String, dynamic> _messageToJson(dynamic message) {
    // TODO: Message 엔티티를 JSON으로 변환
    return {};
  }

  Conversation _conversationFromJson(Map<String, dynamic> json) {
    // TODO: JSON을 Conversation 엔티티로 변환
    throw UnimplementedError();
  }

  ContactProfile _profileFromJson(Map<String, dynamic> json) {
    // TODO: JSON을 ContactProfile 엔티티로 변환
    throw UnimplementedError();
  }
}

