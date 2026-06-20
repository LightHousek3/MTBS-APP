// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Theater _$TheaterFromJson(Map<String, dynamic> json) => _Theater(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String? ?? '',
  address: json['address'] as String,
  phone: json['phone'] as String?,
  coordinates: const TheaterCoordinatesConverter().fromJson(
    json['coordinates'],
  ),
);

Map<String, dynamic> _$TheaterToJson(_Theater instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'address': instance.address,
  'phone': instance.phone,
  'coordinates': const TheaterCoordinatesConverter().toJson(
    instance.coordinates,
  ),
};
