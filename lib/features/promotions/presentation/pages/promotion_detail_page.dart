import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';
import 'package:mtbs_app/features/promotions/presentation/view_models/promotion_controller.dart';

class PromotionDetailPage extends ConsumerStatefulWidget {
  const PromotionDetailPage({required this.promotionId, super.key});

  final String promotionId;

  @override
  ConsumerState<PromotionDetailPage> createState() =>
      _PromotionDetailPageState();
}

class _PromotionDetailPageState extends ConsumerState<PromotionDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.invalidate(promotionDetailProvider(widget.promotionId));
  }

  @override
  Widget build(BuildContext context) {
    final promotion = ref.watch(promotionDetailProvider(widget.promotionId));

    return Scaffold(
      body: promotion.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () =>
              ref.invalidate(promotionDetailProvider(widget.promotionId)),
        ),
        data: (item) => _PromotionDetailContent(promotion: item),
      ),
    );
  }
}

class _PromotionDetailContent extends StatelessWidget {
  const _PromotionDetailContent({required this.promotion});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NestedScrollView(
      headerSliverBuilder: (context, _) => <Widget>[
        SliverAppBar.large(
          expandedHeight: 330,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                NetworkImageCard(
                  imageUrl: promotion.imageUrl,
                  borderRadius: BorderRadius.zero,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0x22000000),
                        Color(0x88000000),
                        Color(0xF2090A0D),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _StatusPill(status: promotion.status),
                      const SizedBox(height: 12),
                      Text(
                        promotion.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
        children: <Widget>[
          _DiscountPanel(promotion: promotion),
          const SizedBox(height: 18),
          _Section(
            title: 'Thời gian áp dụng',
            child: Column(
              children: <Widget>[
                _InfoRow(
                  icon: Icons.play_circle_outline,
                  label: 'Bắt đầu',
                  value: _detailDateFormat.format(promotion.startDate),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.event_busy_outlined,
                  label: 'Kết thúc',
                  value: _detailDateFormat.format(promotion.endDate),
                ),
              ],
            ),
          ),
          if (promotion.description?.trim().isNotEmpty ?? false) ...<Widget>[
            const SizedBox(height: 18),
            _Section(
              title: 'Chi tiết khuyến mãi',
              child: Text(
                promotion.description!.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          _Section(
            title: 'Lưu ý',
            child: Text(
              'Ưu đãi được áp dụng theo điều kiện tại thời điểm đặt vé. Vui lòng kiểm tra trạng thái khuyến mãi trước khi thanh toán.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountPanel extends StatelessWidget {
  const _DiscountPanel({required this.promotion});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountText = _discountText(promotion);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF15151C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.local_offer, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Mức ưu đãi',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  discountText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF15151C),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label, style: const TextStyle(color: Colors.white60)),
      ),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ],
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.68),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
    ),
    child: Text(
      _statusText(status),
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}

final _detailDateFormat = DateFormat('HH:mm, dd/MM/yyyy');
final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

String _discountText(Promotion promotion) {
  if (promotion.discountType == 'PERCENT') {
    return 'Giảm ${promotion.discountValue.toStringAsFixed(0)}%';
  }
  return 'Giảm ${_currencyFormat.format(promotion.discountValue)}';
}

String _statusText(String status) {
  return switch (status) {
    'ACTIVE' => 'Đang áp dụng',
    'UPCOMING' => 'Sắp diễn ra',
    'EXPIRED' => 'Đã hết hạn',
    'INACTIVE' => 'Tạm dừng',
    _ => status,
  };
}
