import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/reviews/domain/entities/review.dart';
import 'package:mtbs_app/features/reviews/presentation/view_models/review_controller.dart';
import 'package:mtbs_app/features/reviews/presentation/widgets/review_widgets.dart';


class MovieReviewsTab extends ConsumerWidget {
  const MovieReviewsTab({required this.movieId, super.key});

  final String movieId;

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Review? existing,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F1116),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReviewFormSheet(movieId: movieId, existing: existing),
    );
    if (result == true) {
      ref.invalidate(movieReviewsProvider(movieId));
      ref.invalidate(myMovieReviewProvider(movieId));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa đánh giá'),
        content: const Text('Bạn có chắc muốn xóa đánh giá này không?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(reviewActionsProvider.notifier).remove(id);
      ref.invalidate(movieReviewsProvider(movieId));
      ref.invalidate(myMovieReviewProvider(movieId));
    } catch (error) {
      if (context.mounted) showAppErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(movieReviewsProvider(movieId));
    final authAsync = ref.watch(authControllerProvider);
    final currentUserId = switch (authAsync) {
      AsyncData(:final value) => value?.id,
      _ => null,
    };

    final myReviewAsync = ref.watch(myMovieReviewProvider(movieId));
    final myReview = switch (myReviewAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(movieReviewsProvider(movieId));
        ref.invalidate(myMovieReviewProvider(movieId));
      },
      child: reviewsAsync.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(movieReviewsProvider(movieId)),
        ),
        data: (result) {
          final reviews = result.reviews;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
            children: <Widget>[
              // ── Header: rating summary ──────────────────────────────
              _RatingSummary(result: result),
              const SizedBox(height: 20),

              // ── Write review button ─────────────────────────────────
              if (currentUserId != null)
                if (myReview != null && myReview.status != 'APPROVED')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: myReview.status == 'REJECTED' ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: myReview.status == 'REJECTED' ? Colors.red.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              myReview.status == 'REJECTED' ? Icons.error_outline : Icons.pending_actions,
                              color: myReview.status == 'REJECTED' ? Colors.redAccent : Colors.orangeAccent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                myReview.status == 'REJECTED'
                                    ? 'Đánh giá của bạn đã bị từ chối do vi phạm tiêu chuẩn cộng đồng.'
                                    : 'Đánh giá của bạn đang chờ kiểm duyệt.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: myReview.status == 'REJECTED' ? Colors.redAccent : Colors.orangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _openForm(context, ref, existing: myReview),
                              child: const Text('Chỉnh sửa'),
                            ),
                            TextButton(
                              onPressed: () => _delete(context, ref, myReview.id),
                              child: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                else if (myReview == null)
                  OutlinedButton.icon(
                    onPressed: () => _openForm(context, ref),
                    icon: const Icon(Icons.rate_review_outlined),
                    label: const Text('Viết đánh giá của bạn'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
              if (currentUserId != null) const SizedBox(height: 20),

              // ── Reviews list ────────────────────────────────────────
              if (reviews.isEmpty)
                _EmptyReviews(
                  onWrite: currentUserId != null
                      ? () => _openForm(context, ref)
                      : null,
                )
              else
                ...reviews.map((review) {
                  final isOwn = review.user?.id == currentUserId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReviewCard(
                      review: review,
                      isOwn: isOwn,
                      onEdit: () => _openForm(context, ref, existing: review),
                      onDelete: () => _delete(context, ref, review.id),
                    ),
                  );
                }),

              // ── "Từ mọi người" label ────────────────────────────────
              if (reviews.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Nhận xét từ mọi người',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Rating summary banner ────────────────────────────────────────────────────

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.result});
  final ReviewPageResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avg = result.ratingAverage;
    final count = result.totalResults;

    return Row(
      children: <Widget>[
        const Icon(Icons.star_rounded, color: Color(0xFFFFD54F), size: 22),
        const SizedBox(width: 6),
        Text(
          avg > 0 ? avg.toStringAsFixed(1) : '--',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFFD54F),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '/10',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.52),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($count đánh giá)',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews({this.onWrite});
  final VoidCallback? onWrite;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.rate_review_outlined,
              size: 52,
              color: Colors.white.withValues(alpha: 0.28),
            ),
            const SizedBox(height: 12),
            Text(
              'Chưa có đánh giá nào.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
