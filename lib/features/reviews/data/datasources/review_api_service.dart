import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/reviews/domain/entities/review.dart';

class ReviewApiService {
  const ReviewApiService(this._client);
  final DioClient _client;

  Future<(List<Review>, PaginationMeta?)> getMovieReviews(
    String movieId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/reviews/movie/$movieId',
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': 'createdAt:desc',
        'populate': 'user',
      },
    );
    final parsed = ApiResponse<List<Review>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Review.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    );
    return (parsed.data ?? const <Review>[], parsed.meta);
  }

  Future<Review?> getMyReviewForMovie(String movieId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/reviews/me/movie/$movieId',
    );
    final data = response.data?['data'];
    if (data == null) return null;
    return Review.fromJson(data as Map<String, dynamic>);
  }

  Future<Review> createReview({
    required String movieId,
    required int rating,
    String content = '',
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/reviews',
      data: <String, dynamic>{
        'movie': movieId,
        'rating': rating,
        'content': content,
      },
    );
    return ApiResponse<Review>.fromJson(
      response.data!,
      (json) => Review.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<Review> updateReview(
    String id, {
    int? rating,
    String? content,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/reviews/me/$id',
      data: <String, dynamic>{
        'rating': ?rating,
        'content': ?content,
      },
    );
    return ApiResponse<Review>.fromJson(
      response.data!,
      (json) => Review.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<void> deleteReview(String id) async {
    await _client.delete<Map<String, dynamic>>('/reviews/me/$id');
  }
}
