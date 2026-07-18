import 'package:mtbs_app/features/reviews/data/datasources/review_api_service.dart';
import 'package:mtbs_app/features/reviews/domain/entities/review.dart';
import 'package:mtbs_app/features/reviews/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this._service);
  final ReviewApiService _service;

  @override
  Future<ReviewPageResult> getMovieReviews(
    String movieId, {
    int page = 1,
    int limit = 10,
  }) async {
    final (reviews, meta) = await _service.getMovieReviews(
      movieId,
      page: page,
      limit: limit,
    );

    // Compute rating average from fetched reviews when page 1
    double avg = 0;
    if (reviews.isNotEmpty) {
      avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) /
          reviews.length;
    }

    return ReviewPageResult(
      reviews: reviews,
      hasNextPage: meta?.hasNextPage ?? false,
      nextPage: (meta?.page ?? page) + 1,
      totalResults: meta?.totalResults ?? reviews.length,
      ratingAverage: avg,
    );
  }

  @override
  Future<Review?> getMyReviewForMovie(String movieId) =>
      _service.getMyReviewForMovie(movieId);

  @override
  Future<Review> createReview({
    required String movieId,
    required int rating,
    String content = '',
  }) =>
      _service.createReview(
        movieId: movieId,
        rating: rating,
        content: content,
      );

  @override
  Future<Review> updateReview(String id, {int? rating, String? content}) =>
      _service.updateReview(id, rating: rating, content: content);

  @override
  Future<void> deleteReview(String id) => _service.deleteReview(id);
}
