import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_session.dart';

class AuthApiService {
  const AuthApiService(this._client);

  final DioClient _client;

  Future<AuthSession> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: <String, dynamic>{
        'email': email,
        'password': password,
        'deviceId': deviceId,
      },
    );
    return ApiResponse<AuthSession>.fromJson(
      response.data!,
      (json) => AuthSession.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<AuthSession> loginWithGoogle({
    required String idToken,
    required String deviceId,
  }) {
    return _socialLogin('/auth/google', <String, dynamic>{
      'idToken': idToken,
      'deviceId': deviceId,
    });
  }

  Future<AuthSession> loginWithFacebook({
    required String accessToken,
    required String deviceId,
  }) {
    return _socialLogin('/auth/facebook', <String, dynamic>{
      'accessToken': accessToken,
      'deviceId': deviceId,
    });
  }

  Future<AuthSession> _socialLogin(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      path,
      data: payload,
    );
    return ApiResponse<AuthSession>.fromJson(
      response.data!,
      (json) => AuthSession.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<void> register(Map<String, dynamic> payload) async {
    await _client.post<Map<String, dynamic>>('/auth/register', data: payload);
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    await _client.post<Map<String, dynamic>>(
      '/auth/verify-email',
      data: <String, dynamic>{'email': email, 'code': code},
    );
  }

  Future<void> resendVerification(String email) async {
    await _client.post<Map<String, dynamic>>(
      '/auth/resend-verification',
      data: <String, dynamic>{'email': email},
    );
  }

  Future<void> forgotPassword(String email) async {
    await _client.post<Map<String, dynamic>>(
      '/auth/forgot-password',
      data: <String, dynamic>{'email': email},
    );
  }

  Future<RefreshSession> refresh(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/refresh-token',
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
    return ApiResponse<RefreshSession>.fromJson(
      response.data!,
      (json) => RefreshSession.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<void> logout(String refreshToken) async {
    await _client.post<Map<String, dynamic>>(
      '/auth/logout',
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
  }
}
