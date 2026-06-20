// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => _AuthTokens(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
  tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{'user': instance.user, 'tokens': instance.tokens};

_RefreshSession _$RefreshSessionFromJson(Map<String, dynamic> json) =>
    _RefreshSession(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshSessionToJson(_RefreshSession instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
