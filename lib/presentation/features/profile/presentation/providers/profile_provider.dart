import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../domain/usecases/profile/get_profile.dart';
import '../../../../../core/di/providers.dart';

/// 프로필 목록 상태
class ProfileListState {
  final List<ContactProfile> profiles;
  final bool isLoading;
  final String? error;

  const ProfileListState({
    this.profiles = const [],
    this.isLoading = false,
    this.error,
  });

  ProfileListState copyWith({
    List<ContactProfile>? profiles,
    bool? isLoading,
    String? error,
  }) {
    return ProfileListState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 프로필 목록 Provider
final profileListProvider = StateNotifierProvider<ProfileListNotifier, ProfileListState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);

  return ProfileListNotifier(repository: repository);
});

/// 프로필 목록 Notifier
class ProfileListNotifier extends StateNotifier<ProfileListState> {
  final ProfileRepository repository;

  ProfileListNotifier({required this.repository}) : super(const ProfileListState()) {
    loadProfiles();
  }

  /// 프로필 목록 로드
  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getProfiles();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (profiles) => state = state.copyWith(
        isLoading: false,
        profiles: profiles,
      ),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadProfiles();
  }
}

/// 개별 프로필 Provider
final profileProvider = FutureProvider.family<ContactProfile?, String>((ref, profileId) async {
  final repository = ref.watch(profileRepositoryProvider);
  final getProfile = GetProfile(repository);

  final result = await getProfile(profileId);

  return result.fold(
    (failure) => null,
    (profile) => profile,
  );
});

