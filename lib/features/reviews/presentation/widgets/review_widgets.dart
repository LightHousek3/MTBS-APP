import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/features/reviews/domain/entities/review.dart';
import 'package:mtbs_app/features/reviews/presentation/view_models/review_controller.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

String _maskName(String name) {
  final trimmed = name.trim();
  if (trimmed.length <= 2) return trimmed;
  final first = trimmed[0];
  final last = trimmed[trimmed.length - 1];
  final stars = '*' * (trimmed.length - 2).clamp(2, 4);
  return '$first$stars$last';
}

/// Always mask reviewer names for privacy.
String _displayName(Review review) {
  final user = review.user;
  if (user == null) return 'Ẩn danh';
  final full = '${user.firstName} ${user.lastName}'.trim();
  return full.isNotEmpty ? _maskName(full) : _maskName(user.email);
}

// ─── Rating bar ──────────────────────────────────────────────────────────────

class StarRatingBar extends StatelessWidget {
  const StarRatingBar({
    required this.rating,
    this.size = 18,
    this.color = const Color(0xFFFFD54F),
    super.key,
  });

  final int rating;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: color,
        );
      }),
    );
  }
}

// ─── Interactive rating picker ────────────────────────────────────────────────

class StarRatingPicker extends StatelessWidget {
  const StarRatingPicker({
    required this.value,
    required this.onChanged,
    this.size = 28,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (i) {
        final star = i + 1;
        return GestureDetector(
          onTap: () => onChanged(star),
          child: Icon(
            i < value ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: const Color(0xFFFFD54F),
          ),
        );
      }),
    );
  }
}

// ─── Single review card ───────────────────────────────────────────────────────

class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, this.isOwn = false, this.onEdit, this.onDelete, super.key});

  final Review review;
  final bool isOwn;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = _displayName(review);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF16181E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (review.createdAt != null)
                        Text(
                          _formatDate(review.createdAt!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.48),
                          ),
                        ),
                    ],
                  ),
                ),
                StarRatingBar(rating: review.rating, size: 13),
                const SizedBox(width: 6),
                Text(
                  '${review.rating}/10',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFFD54F),
                  ),
                ),
                if (isOwn) ...<Widget>[
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'edit') onEdit?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (_) => const <PopupMenuEntry<String>>[
                      PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Xóa',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            if (review.content.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                review.content.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.48,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}

// ─── Write / Edit review bottom sheet ────────────────────────────────────────

class ReviewFormSheet extends ConsumerStatefulWidget {
  const ReviewFormSheet({
    required this.movieId,
    this.existing,
    super.key,
  });

  final String movieId;
  final Review? existing;

  @override
  ConsumerState<ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends ConsumerState<ReviewFormSheet> {
  late int _rating;
  late TextEditingController _contentCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 8;
    _contentCtrl =
        TextEditingController(text: widget.existing?.content ?? '');
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn số sao.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final actions = ref.read(reviewActionsProvider.notifier);
      final Review result;
      if (widget.existing != null) {
        result = await actions.edit(
          widget.existing!.id,
          rating: _rating,
          content: _contentCtrl.text.trim(),
        );
      } else {
        result = await actions.submit(
          movieId: widget.movieId,
          rating: _rating,
          content: _contentCtrl.text.trim(),
        );
      }
      if (!mounted) return;
      if (result.status == 'PENDING') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đánh giá của bạn đang chờ kiểm duyệt do hệ thống phát hiện từ ngữ nhạy cảm.'),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.existing != null ? 'Cập nhật thành công' : 'Đánh giá thành công')),
        );
      }
      // Refresh list
      ref.invalidate(movieReviewsProvider(widget.movieId));
      ref.invalidate(myMovieReviewProvider(widget.movieId));
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        showAppErrorSnackBar(context, error);
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            isEdit ? 'Chỉnh sửa đánh giá' : 'Đánh giá phim',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Chọn số sao',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              StarRatingPicker(
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                '$_rating/10',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFFD54F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _contentCtrl,
            maxLines: 4,
            maxLength: 2000,
            decoration: const InputDecoration(
              hintText: 'Cảm nghĩ của bạn về phim? (không bắt buộc)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEdit ? 'Lưu thay đổi' : 'Nhận xét'),
            ),
          ),
        ],
      ),
    );
  }
}
