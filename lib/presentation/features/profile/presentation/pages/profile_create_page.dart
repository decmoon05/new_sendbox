import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../core/di/providers.dart';
import '../../../../routes/route_names.dart';

/// 프로필 생성 페이지
class ProfileCreatePage extends ConsumerStatefulWidget {
  const ProfileCreatePage({super.key});

  @override
  ConsumerState<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends ConsumerState<ProfileCreatePage> {
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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final profileId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final newProfile = ContactProfile(
        id: profileId,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        photoUrl: null,
        platforms: [], // 나중에 플랫폼 연동 시 추가
        aiAnalysis: null,
        tags: [],
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        priority: _priority,
        createdAt: now,
        updatedAt: now,
      );

      final repository = ref.read(profileRepositoryProvider);
      final result = await repository.saveProfile(newProfile);

      result.fold(
        (failure) {
          if (mounted) {
            context.showSnackBar('프로필 생성 실패: ${failure.message}');
            setState(() {
              _isLoading = false;
            });
          }
        },
        (_) {
          if (mounted) {
            // 프로필 목록 새로고침
            ref.read(profileListProvider.notifier).refresh();
            // 프로필 상세 페이지로 이동
            Navigator.pushReplacementNamed(
              context,
              RouteNames.profileDetail,
              arguments: profileId,
            );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 연락처'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: '이름 *',
                hint: '연락처 이름',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '이름은 필수입니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: '전화번호',
                hint: '예: 010-1234-5678',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: '이메일',
                hint: '예: example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.isValidEmail()) {
                    return '유효한 이메일 형식이 아닙니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPrioritySelector(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: '메모',
                hint: '이 연락처에 대한 메모를 남겨주세요.',
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '중요도',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final priorityValue = index + 1;
            return Expanded(
              child: IconButton(
                icon: Icon(
                  _priority >= priorityValue ? Icons.star : Icons.star_border,
                  color: _priority >= priorityValue ? AppColors.warning : AppColors.textSecondary,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _priority = priorityValue;
                  });
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

