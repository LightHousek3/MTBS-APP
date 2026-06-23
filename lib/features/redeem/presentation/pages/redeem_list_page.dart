import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';
import 'package:mtbs_app/features/redeem/presentation/view_models/redeem_controller.dart';

class RedeemListPage extends ConsumerStatefulWidget {
  const RedeemListPage({super.key});

  @override
  ConsumerState<RedeemListPage> createState() => _RedeemListPageState();
}

class _RedeemListPageState extends ConsumerState<RedeemListPage> {
  final Map<String, int> _amounts = <String, int>{};
  final Set<String> _submitting = <String>{};

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (!mounted) return;
      ref.invalidate(redeemListProvider);
    });
  }

  int _amountFor(Redeem redeem) => _amounts[redeem.id] ?? 1;

  void _changeAmount(Redeem redeem, int delta) {
    final current = _amountFor(redeem);
    final next = (current + delta).clamp(1, redeem.quantity);
    setState(() => _amounts[redeem.id] = next);
  }

  Future<void> _redeem(Redeem redeem, AuthUser? user) async {
    if (user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để đổi quà.')),
        );
      return;
    }

    final amount = _amountFor(redeem);
    final totalPoints = redeem.pointsRequired * amount;
    if (user.loyaltyPoints < totalPoints) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Điểm tích lũy không đủ để đổi quà.')),
        );
      return;
    }

    final contact = await showDialog<Map<String, String>?>(
      context: context,
      builder: (context) => _RedeemContactDialog(
        redeem: redeem,
        amount: amount,
        initialAddress: user.address ?? '',
        initialPhone: user.phone ?? '',
      ),
    );
    if (contact == null || !mounted) return;

    setState(() => _submitting.add(redeem.id));
    try {
      await ref
          .read(redeemRepositoryProvider)
          .redeemGift(
            redeemId: redeem.id,
            amount: amount,
            address: contact['address']!,
            phone: contact['phone']!,
          );
      if (!mounted) return;
      _amounts[redeem.id] = 1;
      ref.invalidate(redeemGiftHistoryProvider);
      ref.invalidate(redeemDetailProvider);
      final _ = await ref.refresh(redeemListProvider.future);
      await ref.read(authControllerProvider.notifier).refreshUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đổi quà thành công!')));
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _submitting.remove(redeem.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final redeems = ref.watch(redeemListProvider);
    final user = switch (ref.watch(authControllerProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Đổi quà'), centerTitle: false),
      body: redeems.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(redeemListProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            final _ = await ref.refresh(redeemListProvider.future);
            await ref.read(authControllerProvider.notifier).refreshUser();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              _RedeemBalanceHeader(user: user),
              const SizedBox(height: 16),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: Text('Chưa có quà đổi điểm nào.')),
                )
              else
                ...items.map(
                  (redeem) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RedeemListTile(
                      redeem: redeem,
                      amount: _amountFor(redeem),
                      isSubmitting: _submitting.contains(redeem.id),
                      onDecrease: () => _changeAmount(redeem, -1),
                      onIncrease: () => _changeAmount(redeem, 1),
                      onRedeem: () => _redeem(redeem, user),
                      onOpenDetail: () =>
                          context.push(AppRoutePaths.redeemDetail(redeem.id)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RedeemBalanceHeader extends StatelessWidget {
  const _RedeemBalanceHeader({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'bạn';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Xin chào! $name',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bạn có thể đổi quà bằng điểm thành viên tại đây.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.redeem_outlined, color: colorScheme.primary),
              const SizedBox(height: 6),
              Text(
                '${user?.loyaltyPoints ?? 0} điểm',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RedeemListTile extends StatelessWidget {
  const _RedeemListTile({
    required this.redeem,
    required this.amount,
    required this.isSubmitting,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRedeem,
    required this.onOpenDetail,
  });

  final Redeem redeem;
  final int amount;
  final bool isSubmitting;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRedeem;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOutOfStock = redeem.quantity <= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.26),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: onOpenDetail,
            child: SizedBox.square(
              dimension: 72,
              child: NetworkImageCard(
                imageUrl: redeem.image?.url,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  redeem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOutOfStock ? 'Đã hết quà' : 'Kho: ${redeem.quantity} còn',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOutOfStock
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cần: ${redeem.pointsRequired * amount} điểm',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (redeem.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    redeem.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: <Widget>[
              _AmountStepper(
                amount: amount,
                canDecrease: amount > 1 && !isOutOfStock,
                canIncrease: amount < redeem.quantity && !isOutOfStock,
                onDecrease: onDecrease,
                onIncrease: onIncrease,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 74,
                height: 34,
                child: FilledButton(
                  onPressed: isOutOfStock || isSubmitting ? null : onRedeem,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: theme.textTheme.labelLarge,
                  ),
                  child: isSubmitting
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đổi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountStepper extends StatelessWidget {
  const _AmountStepper({
    required this.amount,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int amount;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onPressed: onDecrease,
          ),
          SizedBox(
            width: 34,
            child: Center(
              child: Text(
                '$amount',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: enabled ? onPressed : null,
    icon: Icon(icon, size: 18),
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 30, height: 30),
  );
}

class _RedeemContactDialog extends StatefulWidget {
  const _RedeemContactDialog({
    required this.redeem,
    required this.amount,
    required this.initialAddress,
    required this.initialPhone,
  });

  final Redeem redeem;
  final int amount;
  final String initialAddress;
  final String initialPhone;

  @override
  State<_RedeemContactDialog> createState() => _RedeemContactDialogState();
}

class _RedeemContactDialogState extends State<_RedeemContactDialog> {
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
    final totalPoints = widget.redeem.pointsRequired * widget.amount;

    return AlertDialog(
      title: const Text('Thông tin nhận quà'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Bạn sẽ đổi $totalPoints điểm để nhận ${widget.amount} ${widget.redeem.name}.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ nhận quà',
                  prefixIcon: Icon(Icons.location_on_outlined),
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
              Navigator.pop(context, <String, String>{
                'phone': _phoneController.text.trim(),
                'address': _addressController.text.trim(),
              });
            }
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
