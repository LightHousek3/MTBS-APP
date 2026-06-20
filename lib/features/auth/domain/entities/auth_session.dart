import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AuthUser user,
    required AuthTokens tokens,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}

@freezed
abstract class RefreshSession with _$RefreshSession {
  const factory RefreshSession({
    required AuthUser user,
    required String accessToken,
    required String refreshToken,
  }) = _RefreshSession;

  factory RefreshSession.fromJson(Map<String, dynamic> json) =>
      _$RefreshSessionFromJson(json);
}
