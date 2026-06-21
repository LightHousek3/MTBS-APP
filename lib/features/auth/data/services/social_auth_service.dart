import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mtbs_app/core/config/app_config.dart';
import 'package:mtbs_app/core/errors/app_exception.dart';

class SocialAuthService {
  SocialAuthService({GoogleSignIn? googleSignIn, FacebookAuth? facebookAuth})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
      _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  Future<void>? _googleInitialization;

  Future<String?> getGoogleIdToken() async {
    if (kIsWeb) {
      throw const ValidationException(
        'Social login hiện chỉ được cấu hình cho Android và iOS.',
      );
    }
    if (AppConfig.googleServerClientId.isEmpty) {
      throw const ValidationException(
        'Thiếu GOOGLE_SERVER_CLIENT_ID trong cấu hình Flutter.',
      );
    }

    try {
      await _initializeGoogle();
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const ValidationException(
          'Google không trả về ID token cho backend.',
        );
      }
      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw ValidationException(
        error.description ?? 'Không thể đăng nhập bằng Google.',
        details: error,
      );
    } on AppException {
      rethrow;
    } catch (error) {
      throw UnknownException('Không thể đăng nhập bằng Google: $error');
    }
  }

  Future<String?> getFacebookAccessToken() async {
    if (kIsWeb) {
      throw const ValidationException(
        'Social login hiện chỉ được cấu hình cho Android và iOS.',
      );
    }
    try {
      final result = await _facebookAuth.login(
        permissions: const <String>['email', 'public_profile'],
        loginBehavior: LoginBehavior.nativeWithFallback,
        loginTracking: LoginTracking.enabled,
      );
      if (result.status == LoginStatus.cancelled) return null;
      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw ValidationException(
          result.message ?? 'Không thể đăng nhập bằng Facebook.',
        );
      }
      return result.accessToken!.tokenString;
    } on AppException {
      rethrow;
    } catch (error) {
      throw UnknownException('Không thể đăng nhập bằng Facebook: $error');
    }
  }

  Future<void> _initializeGoogle() async {
    final initialization = _googleInitialization ??= _googleSignIn.initialize(
      clientId:
          defaultTargetPlatform == TargetPlatform.iOS &&
              AppConfig.googleIosClientId.isNotEmpty
          ? AppConfig.googleIosClientId
          : null,
      serverClientId: AppConfig.googleServerClientId,
    );
    try {
      await initialization;
    } catch (_) {
      if (identical(_googleInitialization, initialization)) {
        _googleInitialization = null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Provider sign-out must not prevent the MTBS session from being cleared.
    }
    try {
      await _facebookAuth.logOut();
    } catch (_) {
      // Provider sign-out must not prevent the MTBS session from being cleared.
    }
  }
}
