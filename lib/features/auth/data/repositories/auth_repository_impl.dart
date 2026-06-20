import 'package:mtbs_app/core/errors/app_exception.dart';
import 'package:mtbs_app/core/storage/session_store.dart';
import 'package:mtbs_app/features/auth/data/services/auth_api_service.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._service, this._sessionStore);

  final AuthApiService _service;
  final SessionStore _sessionStore;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final session = await _service.login(email: email, password: password);
    await _sessionStore.saveTokens(
      accessToken: session.tokens.accessToken,
      refreshToken: session.tokens.refreshToken,
    );
    return session.user;
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final refreshToken = _sessionStore.refreshToken;
    if (refreshToken == null) return null;
    try {
      final session = await _service.refresh(refreshToken);
      await _sessionStore.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      return session.user;
    } on AppException {
      await _sessionStore.clear();
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required String address,
    int? age,
    String? phone,
  }) => _service.register(<String, dynamic>{
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'gender': gender,
    'address': address,
    'age': ?age,
    if (phone != null && phone.isNotEmpty) 'phone': phone,
  });

  @override
  Future<void> verifyEmail({required String email, required String code}) =>
      _service.verifyEmail(email: email, code: code);

  @override
  Future<void> resendVerification(String email) =>
      _service.resendVerification(email);

  @override
  Future<void> forgotPassword(String email) => _service.forgotPassword(email);

  @override
  Future<void> logout() async {
    final refreshToken = _sessionStore.refreshToken;
    try {
      if (refreshToken != null) await _service.logout(refreshToken);
    } finally {
      await _sessionStore.clear();
    }
  }
}
