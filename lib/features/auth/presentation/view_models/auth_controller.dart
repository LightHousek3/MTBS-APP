import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/auth/auth_invalidation_notifier.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mtbs_app/features/auth/data/services/auth_api_service.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/domain/repositories/auth_repository.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiServiceProvider),
    ref.watch(sessionStoreProvider),
  );
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

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required String address,
    int? age,
    String? phone,
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

  Future<void> logout() async {
    state = const AsyncLoading();
    await _repository.logout();
    state = const AsyncData(null);
  }
}
