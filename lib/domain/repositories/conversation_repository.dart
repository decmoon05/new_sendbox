import 'package:dartz/dartz.dart';
import '../entities/conversation.dart';
import '../../core/errors/failures.dart';

/// 대화 리포지토리 인터페이스
abstract class ConversationRepository {
  /// 모든 대화 가져오기
  Future<Either<Failure, List<Conversation>>> getConversations();

  /// 특정 대화 가져오기
  Future<Either<Failure, Conversation>> getConversation(String id);

  /// 대화 저장
  Future<Either<Failure, void>> saveConversation(Conversation conversation);

  /// 대화 삭제
  Future<Either<Failure, void>> deleteConversation(String id);

  /// 대화 검색
  Future<Either<Failure, List<Conversation>>> searchConversations(
    String query,
  );
}

