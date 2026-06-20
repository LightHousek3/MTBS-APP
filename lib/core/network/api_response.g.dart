// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  meta: json['meta'] == null
      ? null
      : PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  _ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'meta': instance.meta,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

_PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    _PaginationMeta(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      totalResults: (json['totalResults'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
    );

Map<String, dynamic> _$PaginationMetaToJson(_PaginationMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'totalResults': instance.totalResults,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };
