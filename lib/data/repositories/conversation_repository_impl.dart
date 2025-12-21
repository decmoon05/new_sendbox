import 'package:dartz/dartz.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/conversation_local_ds.dart';
import '../datasources/remote/firebase_datasource.dart';

/// 대화 리포지토리 구현
class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationLocalDataSource localDataSource;
  final FirebaseDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ConversationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      if (await networkInfo.isConnected) {
        // 온라인: 원격에서 가져오고 로컬에 저장
        try {
          final conversations = await remoteDataSource.getConversations();
          
          // 로컬에 저장 (백그라운드)
          for (final conversation in conversations) {
            localDataSource.saveConversation(conversation).catchError((_) {});
          }
          
          return Right(conversations);
        } catch (e) {
          // 원격 실패 시 로컬에서 가져오기
          final localConversations = await localDataSource.getConversations();
          return Right(localConversations);
        }
      } else {
        // 오프라인: 로컬에서만 가져오기
        final conversations = await localDataSource.getConversations();
        return Right(conversations);
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
  Future<Either<Failure, Conversation>> getConversation(String id) async {
    try {
      final conversation = await localDataSource.getConversation(id);
      
      if (conversation == null) {
        return Left(CacheFailure('대화를 찾을 수 없습니다.'));
      }
      
      // 온라인인 경우 원격에서 최신 데이터 가져오기 (백그라운드)
      if (await networkInfo.isConnected) {
        remoteDataSource.getConversations().then((conversations) {
          final updated = conversations.firstWhere(
            (c) => c.id == id,
            orElse: () => conversation,
          );
          localDataSource.saveConversation(updated).catchError((_) {});
        }).catchError((_) {});
      }
      
      return Right(conversation);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('대화를 가져오는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveConversation(Conversation conversation) async {
    try {
      // 로컬에 먼저 저장 (빠른 응답)
      await localDataSource.saveConversation(conversation);
      
      // 온라인인 경우 원격에도 저장 (백그라운드)
      if (await networkInfo.isConnected) {
        remoteDataSource.syncConversation(conversation).catchError((_) {});
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } on ServerException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('대화를 저장하는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    try {
      await localDataSource.deleteConversation(id);
      
      // 온라인인 경우 원격에서도 삭제 (백그라운드)
      if (await networkInfo.isConnected) {
        // TODO: 원격 삭제 구현
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('대화를 삭제하는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> searchConversations(String query) async {
    try {
      final conversations = await localDataSource.getConversations();
      
      final filtered = conversations.where((conv) {
        final lastMessage = conv.lastMessage;
        if (lastMessage == null) return false;
        
        return lastMessage.content.toLowerCase().contains(query.toLowerCase()) ||
               conv.id.contains(query);
      }).toList();
      
      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure('대화 검색에 실패했습니다: ${e.toString()}'));
    }
  }
}

