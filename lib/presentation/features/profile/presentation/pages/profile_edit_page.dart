import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../providers/profile_provider.dart';
import '../../../../../core/di/providers.dart';

/// 프로필 편집 페이지
class ProfileEditPage extends ConsumerStatefulWidget {
  final String profileId;

  const ProfileEditPage({
    super.key,
    required this.profileId,
  });

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  
  int _priority = 3;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileAsync = ref.read(profileProvider(widget.profileId));
    
    await profileAsync.when(
      data: (profile) {
        if (profile != null) {
          _nameController.text = profile.name;
          _phoneController.text = profile.phoneNumber ?? '';
          _emailController.text = profile.email ?? '';
          _notesController.text = profile.notes ?? '';
          _priority = profile.priority;
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentProfile = await ref.read(profileProvider(widget.profileId).future);
      
      final updatedProfile = ContactProfile(
        id: currentProfile.id,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        photoUrl: currentProfile.photoUrl,
        platforms: currentProfile.platforms,
        aiAnalysis: currentProfile.aiAnalysis,
        tags: currentProfile.tags,
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        priority: _priority,
        createdAt: currentProfile.createdAt,
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(profileRepositoryProvider);
      final result = await repository.updateProfile(updatedProfile);

      result.fold(
        (failure) {
          if (mounted) {
            context.showSnackBar('프로필 저장 실패: ${failure.message}');
            setState(() {
              _isLoading = false;
            });
          }
        },
        (_) {
          if (mounted) {
            Navigator.pop(context, true); // 편집 완료 후 돌아가기
          }
        },
      );
    } catch (e) {
      if (mounted) {
        context.showSnackBar('오류가 발생했습니다: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(widget.profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 편집'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                '저장',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: profileAsync.when(
          data: (profile) => profile != null 
              ? _buildEditForm(context, profile)
              : const Center(child: Text('프로필을 찾을 수 없습니다')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('프로필을 불러올 수 없습니다: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(profileProvider(widget.profileId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, ContactProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 프로필 사진 (미래 구현)
            if (profile.photoUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.photoUrl!),
                ),
              )
            else
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    profile.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // 이름
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름 *',
                hintText: '이름을 입력하세요',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // 전화번호
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '전화번호',
                hintText: '010-1234-5678',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // 이메일
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return '올바른 이메일 형식을 입력해주세요';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 우선순위
            const Text(
              '우선순위',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final priority = index + 1;
                return Expanded(
                  child: RadioListTile<int>(
                    title: Text('$priority'),
                    value: priority,
                    groupValue: _priority,
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // 메모
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: '메모',
                hintText: '추가 정보를 입력하세요',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 24),

            // 플랫폼 정보 (읽기 전용)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '연결된 플랫폼',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (profile.platforms.isEmpty)
                      const Text(
                        '연결된 플랫폼이 없습니다',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    else
                      ...profile.platforms.map((platform) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  _getPlatformIcon(platform.platform),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(platform.platform.toUpperCase()),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    platform.identifier,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'sms':
        return Icons.sms;
      case 'kakao':
      case 'kakaotalk':
        return Icons.chat_bubble;
      case 'discord':
        return Icons.discord;
      case 'instagram':
        return Icons.camera_alt;
      case 'telegram':
        return Icons.send;
      default:
        return Icons.messenger;
    }
  }
}

