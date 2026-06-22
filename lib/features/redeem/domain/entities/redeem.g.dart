// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Redeem _$RedeemFromJson(Map<String, dynamic> json) => _Redeem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  pointsRequired: (json['pointsRequired'] as num?)?.toInt() ?? 0,
  image: json['image'] == null
      ? null
      : MediaAsset.fromJson(json['image'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'AVAILABLE',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RedeemToJson(_Redeem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'pointsRequired': instance.pointsRequired,
  'image': instance.image,
  'quantity': instance.quantity,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
};
