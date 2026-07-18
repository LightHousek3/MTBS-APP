import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class ReviewUser with _$ReviewUser {
  const factory ReviewUser({
    required String id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
  }) = _ReviewUser;

  factory ReviewUser.fromJson(Map<String, dynamic> json) =>
      _$ReviewUserFromJson(json);
}

@freezed
abstract class ReviewMovie with _$ReviewMovie {
  const factory ReviewMovie({
    required String id,
    @Default('') String title,
  }) = _ReviewMovie;

  factory ReviewMovie.fromJson(Map<String, dynamic> json) =>
      _$ReviewMovieFromJson(json);
}

/// Converts user field that may be String (id) or Map (populated object).
class ReviewUserConverter
    implements JsonConverter<ReviewUser?, Object?> {
  const ReviewUserConverter();

  @override
  ReviewUser? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) return ReviewUser.fromJson(json);
    if (json is String) return ReviewUser(id: json);
    return null;
  }

  @override
  Object? toJson(ReviewUser? object) => object?.id;
}

/// Converts movie field that may be String (id) or Map (populated object).
class ReviewMovieConverter
    implements JsonConverter<ReviewMovie?, Object?> {
  const ReviewMovieConverter();

  @override
  ReviewMovie? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) return ReviewMovie.fromJson(json);
    if (json is String) return ReviewMovie(id: json);
    return null;
  }

  @override
  Object? toJson(ReviewMovie? object) => object?.id;
}

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    @ReviewUserConverter() ReviewUser? user,
    @ReviewMovieConverter() ReviewMovie? movie,
    @Default(0) int rating,
    @Default('') String content,
    @Default('PENDING') String status,
    DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

@freezed
abstract class ReviewPageResult with _$ReviewPageResult {
  const factory ReviewPageResult({
    required List<Review> reviews,
    @Default(false) bool hasNextPage,
    @Default(1) int nextPage,
    @Default(0) double ratingAverage,
    @Default(0) int totalResults,
  }) = _ReviewPageResult;
}
