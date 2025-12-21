import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/entities/message.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../domain/repositories/conversation_repository.dart';
import '../../../../../domain/repositories/profile_repository.dart';
import '../../../../../core/di/providers.dart';
import '../../../../routes/route_names.dart';

/// 새 대화 시작 페이지
class ConversationCreatePage extends ConsumerStatefulWidget {
  const ConversationCreatePage({super.key});

  @override
  ConsumerState<ConversationCreatePage> createState() => _ConversationCreatePageState();
}

class _ConversationCreatePageState extends ConsumerState<ConversationCreatePage> {
  final _searchController = TextEditingController();
  List<ContactProfile> _allProfiles = [];
  List<ContactProfile> _filteredProfiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _searchController.addListener(_filterProfiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
    });

    final repository = ref.read(profileRepositoryProvider);
    final result = await repository.getProfiles();

    result.fold(
      (failure) {
        if (mounted) {
          context.showSnackBar('프로필 목록 불러오기 실패: ${failure.message}');
          setState(() {
            _isLoading = false;
          });
        }
      },
      (profiles) {
        if (mounted) {
          setState(() {
            _allProfiles = profiles;
            _filteredProfiles = profiles;
            _isLoading = false;
          });
        }
      },
    );
  }

  void _filterProfiles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProfiles = _allProfiles;
      } else {
        _filteredProfiles = _allProfiles.where((profile) {
          return profile.name.toLowerCase().contains(query) ||
                 profile.phoneNumber?.toLowerCase().contains(query) == true ||
                 profile.email?.toLowerCase().contains(query) == true;
        }).toList();
      }
    });
  }

  Future<void> _createConversation(ContactProfile profile) async {
    // 전화번호나 플랫폼 식별자가 있어야 대화 생성 가능
    if (profile.phoneNumber == null && profile.platforms.isEmpty) {
      context.showSnackBar('연락처 정보가 부족합니다. 프로필을 편집하여 전화번호를 추가해주세요.');
      return;
    }

    // 기존 대화가 있는지 확인
    final conversationRepository = ref.read(conversationRepositoryProvider);
    final conversationId = profile.phoneNumber ?? profile.platforms.first.identifier;
    
    final existingResult = await conversationRepository.getConversation(conversationId);
    
    existingResult.fold(
      (_) {
        // 대화가 없으면 새로 생성하고 이동
        _createNewConversation(profile, conversationId);
      },
      (existingConversation) {
        // 대화가 있으면 기존 대화로 이동
        Navigator.pushReplacementNamed(
          context,
          RouteNames.chatDetail,
          arguments: existingConversation.id,
        );
      },
    );
  }

  Future<void> _createNewConversation(ContactProfile profile, String conversationId) async {
    final now = DateTime.now();
    final conversationRepository = ref.read(conversationRepositoryProvider);

    // 플랫폼 결정 (전화번호가 있으면 SMS, 아니면 첫 번째 플랫폼)
    final platform = profile.phoneNumber != null 
        ? 'sms' 
        : (profile.platforms.isNotEmpty ? profile.platforms.first.platform : 'sms');

    final newConversation = Conversation(
      id: conversationId,
      contactId: profile.name,
      platform: platform,
      messages: [],
      lastMessageAt: now,
      unreadCount: 0,
      isPinned: false,
      metadata: {
        'platform': platform,
        if (profile.phoneNumber != null) 'phoneNumber': profile.phoneNumber,
      },
    );

    final result = await conversationRepository.saveConversation(newConversation);

    result.fold(
      (failure) {
        if (mounted) {
          context.showSnackBar('대화 생성 실패: ${failure.message}');
        }
      },
      (_) {
        if (mounted) {
          // 대화 목록 새로고침
          ref.read(chatProvider.notifier).refresh();
          // 대화 상세 페이지로 이동
          Navigator.pushReplacementNamed(
            context,
            RouteNames.chatDetail,
            arguments: conversationId,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 대화 시작'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '연락처 검색...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProfiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? '연락처가 없습니다'
                                  : '검색 결과가 없습니다',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            if (_searchController.text.isEmpty)
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, RouteNames.profileCreate);
                                },
                                icon: const Icon(Icons.person_add),
                                label: const Text('새 연락처 추가'),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = _filteredProfiles[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              backgroundImage: profile.photoUrl != null
                                  ? NetworkImage(profile.photoUrl!)
                                  : null,
                              child: profile.photoUrl == null
                                  ? Text(
                                      profile.name.isNotEmpty
                                          ? profile.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  : null,
                            ),
                            title: Text(profile.name),
                            subtitle: profile.phoneNumber != null
                                ? Text(profile.phoneNumber!)
                                : profile.platforms.isNotEmpty
                                    ? Text('${profile.platforms.length}개 플랫폼')
                                    : const Text('연락처 정보 없음'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _createConversation(profile),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

