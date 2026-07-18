// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewUser _$ReviewUserFromJson(Map<String, dynamic> json) => _ReviewUser(
  id: json['id'] as String,
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  email: json['email'] as String? ?? '',
);

Map<String, dynamic> _$ReviewUserToJson(_ReviewUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };

_ReviewMovie _$ReviewMovieFromJson(Map<String, dynamic> json) => _ReviewMovie(
  id: json['id'] as String,
  title: json['title'] as String? ?? '',
);

Map<String, dynamic> _$ReviewMovieToJson(_ReviewMovie instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.title};

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  user: const ReviewUserConverter().fromJson(json['user']),
  movie: const ReviewMovieConverter().fromJson(json['movie']),
  rating: (json['rating'] as num?)?.toInt() ?? 0,
  content: json['content'] as String? ?? '',
  status: json['status'] as String? ?? 'PENDING',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'user': const ReviewUserConverter().toJson(instance.user),
  'movie': const ReviewMovieConverter().toJson(instance.movie),
  'rating': instance.rating,
  'content': instance.content,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
};
