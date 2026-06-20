import 'package:dio/dio.dart';
import 'package:mtbs_app/core/storage/session_store.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionStore);

  final SessionStore _sessionStore;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sessionStore.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
