import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/entities/message.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/extensions/datetime_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../ai_recommend/presentation/widgets/ai_recommendation_card.dart';
import '../providers/chat_detail_provider.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../domain/repositories/profile_repository.dart';
import '../../../../../core/di/providers.dart';
import '../../../ai_recommend/presentation/providers/ai_recommendation_provider.dart';

/// 대화 상세 페이지
class ChatDetailPage extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatDetailState = ref.watch(chatDetailProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatDetailState.conversation?.contactId ?? '대화',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: 프로필 상세 보기
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(context, chatDetailState),
          ),
          _buildMessageInput(context, chatDetailState),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, ChatDetailState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(chatDetailProvider(widget.conversationId).notifier).refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final conversation = state.conversation;
    if (conversation == null || conversation.messages.isEmpty) {
      return const Center(
        child: Text('메시지가 없습니다'),
      );
    }

    // 스크롤을 맨 아래로 (메시지 로드 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: conversation.messages.length,
      itemBuilder: (context, index) {
        final message = conversation.messages[index];
        // TODO: 실제 사용자 ID로 교체
        final isMe = message.type == MessageType.sent;
        return MessageBubble(message: message, isMe: isMe);
      },
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatDetailState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: () {
                // TODO: AI 추천 표시
                _showAIRecommendation(context);
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '메시지 입력...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(context, state),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _sendMessage(context, state),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context, ChatDetailState state) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // 메시지 전송
    ref.read(chatDetailProvider(widget.conversationId).notifier).sendMessage(text);
    
    _messageController.clear();
    context.hideKeyboard();

    // 스크롤을 맨 아래로
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAIRecommendation(BuildContext context) {
    final conversation = ref.read(chatDetailProvider(widget.conversationId)).conversation;
    if (conversation == null) {
      context.showSnackBar('대화 정보를 불러올 수 없습니다');
      return;
    }

    // 프로필 가져오기
    final profileRepository = ref.read(profileRepositoryProvider);
    profileRepository.getProfile(conversation.contactId).then((result) {
      result.fold(
        (failure) {
          context.showSnackBar('프로필을 불러올 수 없습니다: ${failure.message}');
        },
        (profile) {
          _showAIRecommendationModal(context, conversation, profile);
        },
      );
    });
  }

  void _showAIRecommendationModal(
    BuildContext context,
    Conversation conversation,
    ContactProfile profile,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final messageContext = _messageController.text.trim().isNotEmpty
            ? _messageController.text.trim()
            : '대화를 계속하겠습니다';

        final params = AIRecommendationParams(
          conversation: conversation,
          profile: profile,
          messageContext: messageContext,
        );

        final recommendationState = ref.watch(aiRecommendationProvider(params));

        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'AI 메시지 추천',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final state = recommendationState;
                      
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state.error != null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                              const SizedBox(height: 16),
                              Text(state.error!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(aiRecommendationProvider(params).notifier).refresh();
                                },
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (state.recommendation == null || state.recommendation!.recommendations.isEmpty) {
                        return const Center(
                          child: Text('추천 메시지가 없습니다'),
                        );
                      }
                      
                      return ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: state.recommendation!.recommendations.map((option) {
                          return AIRecommendationCard(
                            option: option,
                            onTap: () {
                              _messageController.text = option.message;
                              Navigator.pop(context);
                            },
                            onCopy: () {
                              Clipboard.setData(ClipboardData(text: option.message));
                              context.showSnackBar('메시지가 복사되었습니다');
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 메시지 버블 위젯
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? const Radius.circular(4) : null,
            bottomLeft: !isMe ? const Radius.circular(4) : null,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.timestamp.formattedTime,
              style: TextStyle(
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

