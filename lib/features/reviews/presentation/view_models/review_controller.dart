import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/reviews/data/review_data_providers.dart';
import 'package:mtbs_app/features/reviews/domain/entities/review.dart';

/// Provides paginated list of approved reviews for a movie.
final movieReviewsProvider =
    FutureProvider.autoDispose.family<ReviewPageResult, String>((ref, movieId) {
  return ref.watch(reviewRepositoryProvider).getMovieReviews(movieId);
});

/// Provides the current user's review for a movie (if any), including PENDING/REJECTED.
final myMovieReviewProvider =
    FutureProvider.autoDispose.family<Review?, String>((ref, movieId) {
  return ref.watch(reviewRepositoryProvider).getMyReviewForMovie(movieId);
});

/// Notifier for write operations: create / update / delete
class ReviewActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Review> submit({
    required String movieId,
    required int rating,
    String content = '',
  }) {
    return ref.read(reviewRepositoryProvider).createReview(
          movieId: movieId,
          rating: rating,
          content: content,
        );
  }

  Future<Review> edit(String id, {int? rating, String? content}) {
    return ref
        .read(reviewRepositoryProvider)
        .updateReview(id, rating: rating, content: content);
  }

  Future<void> remove(String id) {
    return ref.read(reviewRepositoryProvider).deleteReview(id);
  }
}

final reviewActionsProvider =
    AsyncNotifierProvider<ReviewActionsNotifier, void>(
  ReviewActionsNotifier.new,
);
