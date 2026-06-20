import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    required String message,
    T? data,
    PaginationMeta? meta,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @Default(1) int page,
    @Default(10) int limit,
    @Default(0) int totalResults,
    @Default(0) int totalPages,
    @Default(false) bool hasNextPage,
    @Default(false) bool hasPrevPage,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}
