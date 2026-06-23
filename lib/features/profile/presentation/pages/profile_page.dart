import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem_gift.dart';
import 'package:mtbs_app/features/redeem/presentation/view_models/redeem_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int _selectedTab = 0;
  String _historyStatus = 'ALL';
  final Set<String> _cancelling = <String>{};

  Future<void> _refreshVisibleData() async {
    await ref.read(authControllerProvider.notifier).refreshUser();
    if (_selectedTab == 2) {
      final _ = await ref.refresh(
        redeemGiftHistoryProvider(_historyStatus).future,
      );
    }
  }

  Future<void> _cancelGift(RedeemGift gift) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy quà đã đổi?'),
        content: Text(
          'Bạn muốn hủy giao dịch ${gift.transactionNo} và hoàn lại ${gift.spentPoints} điểm?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy quà'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _cancelling.add(gift.id));
    try {
      await ref.read(redeemRepositoryProvider).cancelRedeemGift(gift.id);
      if (!mounted) return;
      ref.invalidate(redeemGiftHistoryProvider);
      ref.invalidate(redeemDetailProvider);
      ref.invalidate(redeemListProvider);
      final _ = await ref.refresh(
        redeemGiftHistoryProvider(_historyStatus).future,
      );
      await ref.read(authControllerProvider.notifier).refreshUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Đã hủy quà và hoàn điểm.')),
        );
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _cancelling.remove(gift.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = switch (authState) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản'), centerTitle: false),
      body: SafeArea(
        child: authState.isLoading && user == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshVisibleData,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: <Widget>[
                    _ProfileHeader(user: user),
                    const SizedBox(height: 18),
                    _ProfileTabs(
                      selectedIndex: _selectedTab,
                      onSelected: (index) {
                        setState(() => _selectedTab = index);
                        if (index == 2) {
                          ref.invalidate(
                            redeemGiftHistoryProvider(_historyStatus),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    if (_selectedTab == 0) ...[
                      _InfoSection(user: user),
                      const SizedBox(height: 18),
                      _ActionSection(
                        onRedeem: user == null
                            ? null
                            : () => context.push(AppRoutePaths.redeems),
                        onLogout: user == null
                            ? null
                            : () => ref
                                  .read(authControllerProvider.notifier)
                                  .logout(),
                      ),
                    ] else if (_selectedTab == 2) ...[
                      _RedeemHistorySection(
                        status: _historyStatus,
                        cancellingIds: _cancelling,
                        onStatusChanged: (status) {
                          ref.invalidate(redeemGiftHistoryProvider(status));
                          setState(() => _historyStatus = status);
                        },
                        onCancel: _cancelGift,
                      ),
                    ] else ...[
                      _ComingSoonSection(
                        icon: _selectedTab == 1
                            ? Icons.confirmation_number_outlined
                            : Icons.favorite_border_rounded,
                        title: _selectedTab == 1
                            ? 'Lịch sử vé'
                            : 'Phim yêu thích',
                      ),
                    ],
                    if (authState.hasError) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Không tải được đầy đủ thông tin tài khoản.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final name = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : 'Khách hàng FilmGo';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 34,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 38,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user == null
                      ? 'Thông tin tài khoản sẽ được hoàn thiện sau.'
                      : 'Thành viên FilmGo',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.stars_rounded,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${user?.loyaltyPoints ?? 0} điểm tích lũy',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
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

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = <String>['Thông tin', 'Ls. vé', 'Ls. đổi quà', 'Yêu thích'];

    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) => _ProfileTab(
          label: labels[index],
          selected: selectedIndex == index,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Thông tin cá nhân',
      trailing: TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('Chỉnh sửa'),
      ),
      children: <Widget>[
        _InfoRow(
          icon: Icons.badge_outlined,
          label: user?.fullName.isNotEmpty == true
              ? user!.fullName
              : 'Chưa cập nhật',
        ),
        _InfoRow(
          icon: Icons.mail_outline_rounded,
          label: user?.email ?? 'Chưa cập nhật',
        ),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: _emptyAsFallback(user?.phone),
        ),
        _InfoRow(
          icon: Icons.cake_outlined,
          label: user?.age == null ? 'Chưa cập nhật' : '${user!.age} tuổi',
        ),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: _emptyAsFallback(user?.address),
        ),
      ],
    );
  }

  static String _emptyAsFallback(String? value) {
    if (value == null || value.trim().isEmpty) return 'Chưa cập nhật';
    return value.trim();
  }
}

class _RedeemHistorySection extends ConsumerWidget {
  const _RedeemHistorySection({
    required this.status,
    required this.cancellingIds,
    required this.onStatusChanged,
    required this.onCancel,
  });

  final String status;
  final Set<String> cancellingIds;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<RedeemGift> onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(redeemGiftHistoryProvider(status));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _HistoryFilterBar(selectedStatus: status, onChanged: onStatusChanged),
        const SizedBox(height: 12),
        history.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: AppHashLoader()),
          ),
          error: (error, _) => AsyncErrorView(
            error: error,
            onRetry: () => ref.invalidate(redeemGiftHistoryProvider(status)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text('Chưa có lịch sử đổi quà.')),
              );
            }

            return Column(
              children: items
                  .map(
                    (gift) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RedeemHistoryCard(
                        gift: gift,
                        isCancelling: cancellingIds.contains(gift.id),
                        onCancel: () => onCancel(gift),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

class _HistoryFilterBar extends StatelessWidget {
  const _HistoryFilterBar({
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = <String, String>{
      'ALL': 'Tất cả',
      'PENDING': 'Đang xử lý',
      'DELIVERING': 'Đang giao',
      'DELIVERED': 'Đã hoàn thành',
      'CANCELLED': 'Đã hủy',
    };

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: selectedStatus == entry.key,
                  onSelected: (_) => onChanged(entry.key),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _RedeemHistoryCard extends StatelessWidget {
  const _RedeemHistoryCard({
    required this.gift,
    required this.isCancelling,
    required this.onCancel,
  });

  final RedeemGift gift;
  final bool isCancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final redeem = gift.redeem;
    final isRefunded = gift.status == 'CANCELLED';
    final pointsColor = isRefunded ? Colors.green : colorScheme.error;
    final pointsPrefix = isRefunded ? '+' : '-';
    final expectedDeliveryDate =
        gift.expectedDeliveryDate ??
        gift.createdAt?.add(const Duration(days: 14));
    final deliveredAt = gift.deliveredAt;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.26),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox.square(
                dimension: 64,
                child: NetworkImageCard(
                  imageUrl: redeem?.image?.url,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      redeem?.name ?? 'Quà đổi điểm',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Số lượng: ${gift.amount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (gift.createdAt != null)
                      Text(
                        'Ngày đổi: ${DateFormat('dd/MM/yyyy').format(gift.createdAt!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (expectedDeliveryDate != null)
                      Text(
                        'Dự kiến giao: ${DateFormat('dd/MM/yyyy').format(expectedDeliveryDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (deliveredAt != null)
                      Text(
                        'Đã giao: ${DateFormat('dd/MM/yyyy').format(deliveredAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(status: gift.status),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '#${gift.transactionNo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$pointsPrefix ${gift.spentPoints} điểm',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: pointsColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (gift.canCancel) ...[
                const SizedBox(width: 8),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: isCancelling ? null : onCancel,
                    child: isCancelling
                        ? const SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Hủy'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'PENDING' => Colors.orange,
      'DELIVERING' => Colors.blue,
      'DELIVERED' => Colors.green,
      'CANCELLED' => Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.onSurfaceVariant,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          _statusLabel(status),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  static String _statusLabel(String status) => switch (status) {
    'PENDING' => 'Đang xử lý',
    'DELIVERING' => 'Đang giao',
    'DELIVERED' => 'Đã hoàn thành',
    'CANCELLED' => 'Đã hủy',
    _ => status,
  };
}

class _ComingSoonSection extends StatelessWidget {
  const _ComingSoonSection({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 42, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chức năng này sẽ được hoàn thiện sau.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.onRedeem, required this.onLogout});

  final VoidCallback? onRedeem;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: 'Tiện ích tài khoản',
      children: <Widget>[
        const _MenuRow(icon: Icons.settings_outlined, title: 'Cài đặt'),
        const _MenuRow(icon: Icons.history_rounded, title: 'Yêu cầu hoàn tiền'),
        _MenuRow(
          icon: Icons.card_giftcard_outlined,
          title: 'Đổi quà thân thiết',
          onTap: onRedeem,
          enabled: onRedeem != null,
        ),
        const _MenuRow(icon: Icons.lock_outline_rounded, title: 'Đổi mật khẩu'),
        const _MenuRow(
          icon: Icons.help_outline_rounded,
          title: 'Trợ giúp & Hỗ trợ',
        ),
        _MenuRow(
          icon: Icons.logout_rounded,
          title: 'Đăng xuất',
          onTap: onLogout,
          enabled: onLogout != null,
          destructive: true,
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    this.onTap,
    this.enabled = false,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tint = destructive
        ? colorScheme.error
        : enabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return ListTile(
      enabled: enabled,
      onTap: onTap,
      leading: Icon(icon, color: tint),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: destructive ? colorScheme.error : null,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: enabled && !destructive
          ? Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
            )
          : null,
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }
}
