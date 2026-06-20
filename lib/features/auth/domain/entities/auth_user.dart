import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? avatar,
    String? address,
    String? phone,
    int? age,
    @Default(0) int loyaltyPoints,
    @Default('OTHER') String gender,
    @Default('USER') String role,
    @Default('ACTIVE') String status,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

extension AuthUserX on AuthUser {
  String get fullName => '$firstName $lastName'.trim();
}
