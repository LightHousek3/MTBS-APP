import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';
import 'package:mtbs_app/features/redeem/presentation/view_models/redeem_controller.dart';

class RedeemDetailPage extends ConsumerStatefulWidget {
  const RedeemDetailPage({required this.redeemId, super.key});
  final String redeemId;

  @override
  ConsumerState<RedeemDetailPage> createState() => _RedeemDetailPageState();
}

class _RedeemDetailPageState extends ConsumerState<RedeemDetailPage> {
  bool _isRedeeming = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.invalidate(redeemDetailProvider(widget.redeemId));
    });
  }

  Future<void> _handleRedeem(Redeem redeem) async {
    final user = switch (ref.read(authControllerProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    if (user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để đổi quà.')),
        );
      return;
    }

    if (user.loyaltyPoints < redeem.pointsRequired) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Điểm tích lũy không đủ để đổi quà.')),
        );
      return;
    }

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (context) => _RedeemConfirmDialog(
        redeem: redeem,
        initialAddress: user.address ?? '',
        initialPhone: user.phone ?? '',
      ),
    );

    if (result == null || !mounted) return;

    final phone = result['phone']!;
    final address = result['address']!;

    setState(() => _isRedeeming = true);
    try {
      await ref
          .read(redeemRepositoryProvider)
          .redeemGift(
            redeemId: widget.redeemId,
            address: address,
            phone: phone,
          );
      if (!mounted) return;
      ref.invalidate(redeemGiftHistoryProvider);
      final _ = await ref.refresh(redeemDetailProvider(widget.redeemId).future);
      ref.invalidate(redeemListProvider);
      await ref.read(authControllerProvider.notifier).refreshUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đổi quà thành công!')));
    } catch (error) {
      if (!mounted) return;
      showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _isRedeeming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(redeemDetailProvider(widget.redeemId));
    final theme = Theme.of(context);
    final user = switch (ref.watch(authControllerProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    return Scaffold(
      body: detail.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => Scaffold(
          appBar: AppBar(title: const Text('Chi Tiết Quà')),
          body: AsyncErrorView(
            error: error,
            onRetry: () =>
                ref.invalidate(redeemDetailProvider(widget.redeemId)),
          ),
        ),
        data: (redeem) {
          final isOutOfStock = redeem.quantity <= 0;
          final hasEnoughPoints =
              user != null && user.loyaltyPoints >= redeem.pointsRequired;

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => <Widget>[
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  stretch: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        NetworkImageCard(
                          imageUrl: redeem.image?.url,
                          borderRadius: BorderRadius.zero,
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0x33000000),
                                Color(0x66000000),
                                Color(0xF2090A0D),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 92),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      redeem.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _InfoChip(
                          icon: Icons.stars_rounded,
                          label: '${redeem.pointsRequired} điểm',
                          iconColor: theme.colorScheme.primary,
                        ),
                        _InfoChip(
                          icon: isOutOfStock
                              ? Icons.info_outline
                              : Icons.check_circle_outline,
                          label: isOutOfStock
                              ? 'Hết quà'
                              : 'Còn ${redeem.quantity} phần',
                          iconColor: isOutOfStock ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (user != null) ...[
                      _PointsProgressCard(
                        userPoints: user.loyaltyPoints,
                        requiredPoints: redeem.pointsRequired,
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (redeem.description.isNotEmpty) ...[
                      _Section(
                        title: 'Mô tả quà tặng',
                        child: Text(
                          redeem.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.48,
                            color: Colors.white.withValues(alpha: 0.86),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _Section(
                      title: 'Quy định đổi quà',
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF16181E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _RuleItem(
                                icon: Icons.info_outline,
                                text:
                                    'Quà tặng chỉ có giá trị khi đổi bằng điểm tích lũy thành viên.',
                              ),
                              SizedBox(height: 8),
                              _RuleItem(
                                icon: Icons.phone_android,
                                text:
                                    'Vui lòng cung cấp chính xác Số điện thoại và Địa chỉ để nhận quà.',
                              ),
                              SizedBox(height: 8),
                              _RuleItem(
                                icon: Icons.local_shipping_outlined,
                                text:
                                    'Hệ thống sẽ liên hệ để xác nhận và giao quà trong vòng 14 ngày làm việc.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: const Color(0xFF111318),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                ),
              ),
              child: GradientButton(
                label: isOutOfStock ? 'Hết quà' : 'Đổi quà ngay',
                isLoading: _isRedeeming,
                onPressed: isOutOfStock
                    ? null
                    : (user != null && !hasEnoughPoints)
                    ? null
                    : () => _handleRedeem(redeem),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PointsProgressCard extends StatelessWidget {
  const _PointsProgressCard({
    required this.userPoints,
    required this.requiredPoints,
  });

  final int userPoints;
  final int requiredPoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasEnough = userPoints >= requiredPoints;
    final progress = (userPoints / requiredPoints).clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF16181E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasEnough
              ? Colors.green.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  hasEnough ? Icons.check_circle : Icons.stars_rounded,
                  color: hasEnough ? Colors.green : theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasEnough
                        ? 'Bạn đã đủ điểm để đổi quà này!'
                        : 'Điểm tích lũy hiện tại của bạn',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: hasEnough ? Colors.green : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasEnough) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$userPoints / $requiredPoints điểm',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Thiếu ${requiredPoints - userPoints} điểm',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Sau khi đổi, bạn sẽ còn ${userPoints - requiredPoints} điểm.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 16, color: iconColor),
    label: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
    visualDensity: VisualDensity.compact,
    backgroundColor: const Color(0xFF16181E),
    side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _RedeemConfirmDialog extends StatefulWidget {
  const _RedeemConfirmDialog({
    required this.redeem,
    required this.initialAddress,
    required this.initialPhone,
  });

  final Redeem redeem;
  final String initialAddress;
  final String initialPhone;

  @override
  State<_RedeemConfirmDialog> createState() => _RedeemConfirmDialogState();
}

class _RedeemConfirmDialogState extends State<_RedeemConfirmDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Thông Tin Nhận Quà'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bạn đang đổi ${widget.redeem.pointsRequired} điểm để nhận "${widget.redeem.name}". Vui lòng xác nhận thông tin giao hàng.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ nhận quà',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ nhận quà';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, {
                'phone': _phoneController.text.trim(),
                'address': _addressController.text.trim(),
              });
            }
          },
          child: const Text('Xác nhận đổi'),
        ),
      ],
    );
  }
}
