import 'package:mtbs_app/features/reviews/domain/entities/review.dart';

abstract interface class ReviewRepository {
  Future<ReviewPageResult> getMovieReviews(
    String movieId, {
    int page = 1,
    int limit = 10,
  });

  Future<Review?> getMyReviewForMovie(String movieId);

  Future<Review> createReview({
    required String movieId,
    required int rating,
    String content = '',
  });

  Future<Review> updateReview(
    String id, {
    int? rating,
    String? content,
  });

  Future<void> deleteReview(String id);
}
