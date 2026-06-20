import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStore {
  SessionStore(this._storage);

  static const _refreshTokenKey = 'mtbs_refresh_token';
  final FlutterSecureStorage _storage;

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get hasRefreshToken => _refreshToken?.isNotEmpty ?? false;

  Future<void> initialize() async {
    _refreshToken = await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  void updateAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _refreshTokenKey);
  }
}
