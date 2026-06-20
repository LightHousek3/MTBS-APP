import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mtbs_app/core/storage/session_store.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required Dio dio,
    required Dio refreshDio,
    required SessionStore sessionStore,
    required VoidCallback onUnauthorized,
  }) : _dio = dio,
       _refreshDio = refreshDio,
       _sessionStore = sessionStore,
       _onUnauthorized = onUnauthorized;

  final Dio _dio;
  final Dio _refreshDio;
  final SessionStore _sessionStore;
  final VoidCallback _onUnauthorized;
  Future<String?>? _refreshing;

  static const _ignoredPaths = <String>{
    '/auth/login',
    '/auth/register',
    '/auth/refresh-token',
    '/auth/logout',
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == 401 &&
        request.extra['retried'] != true &&
        !_ignoredPaths.any(request.path.endsWith) &&
        _sessionStore.hasRefreshToken;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    try {
      final token = await (_refreshing ??= _refreshAccessToken());
      if (token == null) {
        await _sessionStore.clear();
        _onUnauthorized();
        handler.next(err);
        return;
      }
      request.extra['retried'] = true;
      request.headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _dio.fetch<Object?>(request));
    } on DioException catch (refreshError) {
      handler.next(refreshError);
    } finally {
      _refreshing = null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: <String, dynamic>{'refreshToken': _sessionStore.refreshToken},
      );
      final body = response.data;
      final data = body?['data'];
      if (data is! Map<String, dynamic>) return null;
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      if (accessToken is! String || refreshToken is! String) return null;
      await _sessionStore.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return accessToken;
    } on DioException {
      await _sessionStore.clear();
      _onUnauthorized();
      rethrow;
    }
  }
}
