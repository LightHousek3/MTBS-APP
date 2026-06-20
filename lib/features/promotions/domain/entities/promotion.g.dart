// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Promotion _$PromotionFromJson(Map<String, dynamic> json) => _Promotion(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  discountType: json['discountType'] as String,
  discountValue: (json['discountValue'] as num).toDouble(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$PromotionToJson(_Promotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
    };
