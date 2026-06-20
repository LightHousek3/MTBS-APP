// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  age: (json['age'] as num?)?.toInt(),
  loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt() ?? 0,
  gender: json['gender'] as String? ?? 'OTHER',
  role: json['role'] as String? ?? 'USER',
  status: json['status'] as String? ?? 'ACTIVE',
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'avatar': instance.avatar,
  'address': instance.address,
  'phone': instance.phone,
  'age': instance.age,
  'loyaltyPoints': instance.loyaltyPoints,
  'gender': instance.gender,
  'role': instance.role,
  'status': instance.status,
};
