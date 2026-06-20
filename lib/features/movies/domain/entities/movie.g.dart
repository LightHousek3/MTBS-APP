// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Genre _$GenreFromJson(Map<String, dynamic> json) =>
    _Genre(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$GenreToJson(_Genre instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_MediaAsset _$MediaAssetFromJson(Map<String, dynamic> json) => _MediaAsset(
  url: json['url'] as String?,
  publicId: json['publicId'] as String?,
);

Map<String, dynamic> _$MediaAssetToJson(_MediaAsset instance) =>
    <String, dynamic>{'url': instance.url, 'publicId': instance.publicId};

_Movie _$MovieFromJson(Map<String, dynamic> json) => _Movie(
  id: json['id'] as String,
  title: json['title'] as String,
  genres: json['genres'] == null
      ? const <Genre>[]
      : const GenreListConverter().fromJson(json['genres']),
  description: json['description'] as String? ?? '',
  author: json['author'] as String? ?? '',
  image: json['image'] == null
      ? null
      : MediaAsset.fromJson(json['image'] as Map<String, dynamic>),
  trailer: json['trailer'] == null
      ? null
      : MediaAsset.fromJson(json['trailer'] as Map<String, dynamic>),
  type: json['type'] as String? ?? '2D',
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  origin: json['origin'] as String? ?? '',
  releaseDate: json['releaseDate'] == null
      ? null
      : DateTime.parse(json['releaseDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  ageRating: json['ageRating'] as String? ?? 'P',
  actors:
      (json['actors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  totalBookings: (json['totalBookings'] as num?)?.toInt() ?? 0,
  ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$MovieToJson(_Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'genres': const GenreListConverter().toJson(instance.genres),
  'description': instance.description,
  'author': instance.author,
  'image': instance.image,
  'trailer': instance.trailer,
  'type': instance.type,
  'duration': instance.duration,
  'origin': instance.origin,
  'releaseDate': instance.releaseDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'ageRating': instance.ageRating,
  'actors': instance.actors,
  'totalBookings': instance.totalBookings,
  'ratingAverage': instance.ratingAverage,
};
