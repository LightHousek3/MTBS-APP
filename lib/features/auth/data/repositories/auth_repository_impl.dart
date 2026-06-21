import 'package:mtbs_app/core/errors/app_exception.dart';
import 'package:mtbs_app/core/storage/device_id_store.dart';
import 'package:mtbs_app/core/storage/session_store.dart';
import 'package:mtbs_app/features/auth/data/services/auth_api_service.dart';
import 'package:mtbs_app/features/auth/data/services/social_auth_service.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_session.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._service,
    this._socialAuthService,
    this._sessionStore,
    this._deviceIdStore,
  );

  final AuthApiService _service;
  final SocialAuthService _socialAuthService;
  final SessionStore _sessionStore;
  final DeviceIdStore _deviceIdStore;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final session = await _service.login(
      email: email,
      password: password,
      deviceId: await _deviceIdStore.getOrCreate(),
    );
    return _persistSession(session);
  }

  @override
  Future<AuthUser?> loginWithGoogle() async {
    final idToken = await _socialAuthService.getGoogleIdToken();
    if (idToken == null) return null;
    final session = await _service.loginWithGoogle(
      idToken: idToken,
      deviceId: await _deviceIdStore.getOrCreate(),
    );
    return _persistSession(session);
  }

  @override
  Future<AuthUser?> loginWithFacebook() async {
    final accessToken = await _socialAuthService.getFacebookAccessToken();
    if (accessToken == null) return null;
    final session = await _service.loginWithFacebook(
      accessToken: accessToken,
      deviceId: await _deviceIdStore.getOrCreate(),
    );
    return _persistSession(session);
  }

  Future<AuthUser> _persistSession(AuthSession session) async {
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
  Future<String> forgotPassword(String email) => _service.forgotPassword(email);

  @override
  Future<void> logout() async {
    final refreshToken = _sessionStore.refreshToken;
    try {
      if (refreshToken != null) await _service.logout(refreshToken);
    } finally {
      await _sessionStore.clear();
      await _socialAuthService.signOut();
    }
  }
}
