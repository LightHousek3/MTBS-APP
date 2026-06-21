import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser?> loginWithGoogle();
  Future<AuthUser?> loginWithFacebook();
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    required String address,
    int? age,
    String? phone,
  });
  Future<void> verifyEmail({required String email, required String code});
  Future<void> resendVerification(String email);
  Future<String> forgotPassword(String email);
  Future<AuthUser?> restoreSession();
  Future<void> logout();
}
