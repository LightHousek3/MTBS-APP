import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/auth/auth_invalidation_notifier.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mtbs_app/features/auth/data/services/auth_api_service.dart';
import 'package:mtbs_app/features/auth/data/services/social_auth_service.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/domain/repositories/auth_repository.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiServiceProvider),
    ref.watch(socialAuthServiceProvider),
    ref.watch(sessionStoreProvider),
    ref.watch(deviceIdStoreProvider),
  );
});

final socialAuthServiceProvider = Provider<SocialAuthService>((ref) {
  return SocialAuthService();
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthUser?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<AuthUser?> build() {
    ref.watch(authInvalidationProvider);
    final currentUser = _currentUser;
    if (currentUser != null) return Future<AuthUser?>.value(currentUser);
    return _repository.restoreSession();
  }

  AuthUser? get _currentUser {
    final currentState = state;
    return switch (currentState) {
      AsyncData(:final value) => value,
      _ => null,
    };
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.login(email: email.trim(), password: password),
    );
    return !state.hasError;
  }

  Future<bool> loginWithGoogle() => _socialLogin(_repository.loginWithGoogle);

  Future<bool> loginWithFacebook() =>
      _socialLogin(_repository.loginWithFacebook);

  Future<bool> _socialLogin(Future<AuthUser?> Function() authenticate) async {
    final previousUser = _currentUser;
    state = const AsyncLoading();
    try {
      final user = await authenticate();
      if (user == null) {
        state = AsyncData(previousUser);
        return false;
      }
      state = AsyncData(user);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required String address,
    required int age,
    required String phone,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        address: address,
        age: age,
        phone: phone,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    state = const AsyncLoading();
    try {
      await _repository.verifyEmail(email: email, code: code);
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> resendVerification(String email) async {
    final previousUser = _currentUser;
    state = const AsyncLoading();
    try {
      await _repository.resendVerification(email.trim());
      state = AsyncData(previousUser);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<String?> forgotPassword(String email) async {
    final previousUser = _currentUser;
    state = const AsyncLoading();
    try {
      final message = await _repository.forgotPassword(email.trim());
      state = AsyncData(previousUser);
      return message;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = AsyncData(_currentUser);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? address,
    String? phone,
    int? age,
    String? gender,
  }) async {
    final previousUser = _currentUser;
    state = const AsyncLoading();
    try {
      final updatedUser = await _repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        address: address,
        phone: phone,
        age: age,
        gender: gender,
      );
      state = AsyncData(updatedUser);
      return true;
    } catch (error, stackTrace) {
      state = previousUser == null
          ? AsyncError(error, stackTrace)
          : AsyncData(previousUser);
      return false;
    }
  }

  Future<List<AuthUser>> getUsers() => _repository.getUsers();

  Future<bool> changeUserStatus({
    required String userId,
    required String status,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.changeUserStatus(userId: userId, status: status);
      state = AsyncData(_currentUser);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }

  Future<void> refreshUser() async {
    final previousUser = _currentUser;
    try {
      state = AsyncData(await _repository.getCurrentUser());
    } catch (error, stackTrace) {
      state = previousUser == null
          ? AsyncError(error, stackTrace)
          : AsyncData(previousUser);
      if (previousUser == null) rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await _repository.logout();
    state = const AsyncData(null);
  }
}
