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
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem_gift.dart';
import 'package:mtbs_app/features/redeem/presentation/view_models/redeem_controller.dart';
import 'package:mtbs_app/features/waitlist/data/waitlist_data_providers.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_item.dart';
import 'package:mtbs_app/features/waitlist/presentation/view_models/waitlist_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int _selectedTab = 0;
  String _bookingStatus = 'ALL';
  String _historyStatus = 'ALL';
  String? _lastTabQuery;
  final Set<String> _cancelling = <String>{};
  final Set<String> _cancellingBookings = <String>{};
  final Set<String> _removingWaitlistMovies = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabQuery = GoRouterState.of(context).uri.queryParameters['tab'];
    if (tabQuery == _lastTabQuery) return;

    _lastTabQuery = tabQuery;
    if (tabQuery == 'bookings') {
      _selectedTab = 1;
      _bookingStatus = 'ALL';
    }
  }

  Future<void> _refreshVisibleData() async {
    await ref.read(authControllerProvider.notifier).refreshUser();
    if (_selectedTab == 1) {
      final _ = await ref.refresh(
        bookingHistoryProvider(_bookingStatus).future,
      );
    } else if (_selectedTab == 2) {
      final _ = await ref.refresh(
        redeemGiftHistoryProvider(_historyStatus).future,
      );
    } else if (_selectedTab == 3) {
      final _ = await ref.refresh(waitlistProvider.future);
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

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy vé?'),
        content: Text(
          'Bạn muốn hủy booking #${_shortBookingCode(booking.id)}?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy vé'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _cancellingBookings.add(booking.id));
    try {
      await ref.read(bookingRepositoryProvider).cancelBooking(booking.id);
      ref
        ..invalidate(bookingHistoryProvider)
        ..invalidate(bookingDetailsProvider(booking.id))
        ..invalidate(pendingBookingControllerProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đã hủy vé.')));
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _cancellingBookings.remove(booking.id));
    }
  }

  void _showBookingDetails(Booking booking) {
    showDialog<void>(
      context: context,
      builder: (_) => _BookingDetailDialog(
        bookingId: booking.id,
        isCancelling: _cancellingBookings.contains(booking.id),
        onCancel: _cancelBooking,
      ),
    );
  }

  Future<void> _removeWaitlistMovie(WaitlistItem item) async {
    final movieId = item.movie.id;
    setState(() => _removingWaitlistMovies.add(movieId));
    try {
      await ref.read(waitlistRepositoryProvider).removeMovie(movieId);
      ref
        ..invalidate(waitlistProvider)
        ..invalidate(waitlistStatusProvider(movieId));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Đã xoá ${item.movie.title} khỏi danh sách chờ.'),
          ),
        );
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _removingWaitlistMovies.remove(movieId));
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
        child: user == null
            ? _GuestAccountView(
                hasError: authState.hasError,
                onLogin: () => context.push(
                  AppRoutePaths.loginFrom(AppRoutePaths.account),
                ),
              )
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
                        if (index == 1) {
                          ref.invalidate(
                            bookingHistoryProvider(_bookingStatus),
                          );
                        } else if (index == 2) {
                          ref.invalidate(
                            redeemGiftHistoryProvider(_historyStatus),
                          );
                        } else if (index == 3) {
                          ref.invalidate(waitlistProvider);
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    if (_selectedTab == 0) ...[
                      _InfoSection(user: user),
                      const SizedBox(height: 18),
                      _ActionSection(
                        onRedeem: () => context.push(AppRoutePaths.redeems),
                        onLogout: () =>
                            ref.read(authControllerProvider.notifier).logout(),
                      ),
                    ] else if (_selectedTab == 1) ...[
                      _BookingHistorySection(
                        status: _bookingStatus,
                        cancellingIds: _cancellingBookings,
                        onStatusChanged: (status) {
                          ref.invalidate(bookingHistoryProvider(status));
                          setState(() => _bookingStatus = status);
                        },
                        onOpenDetails: _showBookingDetails,
                        onCancel: _cancelBooking,
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
                    ] else if (_selectedTab == 3) ...[
                      _WaitlistSection(
                        removingMovieIds: _removingWaitlistMovies,
                        onRemove: _removeWaitlistMovie,
                      ),
                    ] else ...[
                      _ComingSoonSection(
                        icon: Icons.confirmation_number_outlined,
                        title: 'Lịch sử vé',
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

class _GuestAccountView extends StatelessWidget {
  const _GuestAccountView({required this.hasError, required this.onLogin});

  final bool hasError;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 38,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 42,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Đăng nhập để xem tài khoản',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Theo dõi vé, điểm thưởng, quà đã đổi và danh sách phim chờ của bạn.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (hasError) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  'Không thể khôi phục phiên đăng nhập. Vui lòng đăng nhập lại.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Đăng nhập'),
                ),
              ),
            ],
          ),
        ),
      ],
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
        : 'Khách hàng MTBS';

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
                      : 'Thành viên MTBS',
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
    const labels = <String>[
      'Thông tin',
      'Ls. vé',
      'Ls. đổi quà',
      'Danh sách chờ',
    ];

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

class _BookingHistorySection extends ConsumerWidget {
  const _BookingHistorySection({
    required this.status,
    required this.cancellingIds,
    required this.onStatusChanged,
    required this.onOpenDetails,
    required this.onCancel,
  });

  final String status;
  final Set<String> cancellingIds;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<Booking> onOpenDetails;
  final ValueChanged<Booking> onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingHistoryProvider(status));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _BookingFilterBar(selectedStatus: status, onChanged: onStatusChanged),
        const SizedBox(height: 12),
        bookings.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: AppHashLoader()),
          ),
          error: (error, _) => AsyncErrorView(
            error: error,
            onRetry: () => ref.invalidate(bookingHistoryProvider(status)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text('Chưa có lịch sử đặt vé.')),
              );
            }

            return Column(
              children: items
                  .map(
                    (booking) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BookingHistoryCard(
                        booking: booking,
                        isCancelling: cancellingIds.contains(booking.id),
                        onTap: () => onOpenDetails(booking),
                        onCancel: () => onCancel(booking),
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

class _BookingFilterBar extends StatelessWidget {
  const _BookingFilterBar({
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = <String, String>{
      'ALL': 'Tất cả',
      'PENDING': 'Chờ chiếu',
      'CONFIRMED': 'Đã xem',
      'CANCELLED': 'Đã hủy',
      'REFUNDED': 'Hoàn tiền',
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

class _BookingHistoryCard extends StatelessWidget {
  const _BookingHistoryCard({
    required this.booking,
    required this.isCancelling,
    required this.onTap,
    required this.onCancel,
  });

  final Booking booking;
  final bool isCancelling;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final movie = booking.showtime.movie;
    final theater = booking.showtime.theater;
    final canCancel = booking.isPending;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
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
                  SizedBox(
                    width: 62,
                    height: 82,
                    child: NetworkImageCard(
                      imageUrl: movie?.imageUrl,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          movie?.title ?? 'Vé xem phim',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _MovieMetaLine(
                          icon: Icons.location_on_outlined,
                          label: theater?.name ?? 'Rạp chiếu',
                        ),
                        const SizedBox(height: 3),
                        _MovieMetaLine(
                          icon: Icons.schedule_rounded,
                          label: DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(booking.showtime.startTime),
                        ),
                        const SizedBox(height: 3),
                        _MovieMetaLine(
                          icon: Icons.event_seat_outlined,
                          label: booking.seatNumbers.join(', '),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BookingStatusPill(status: booking.status),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '#${_shortBookingCode(booking.id)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _money(booking.payableTotal),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (canCancel) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: isCancelling ? null : onCancel,
                        child: isCancelling
                            ? const SizedBox.square(
                                dimension: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Hủy vé'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingDetailDialog extends ConsumerWidget {
  const _BookingDetailDialog({
    required this.bookingId,
    required this.isCancelling,
    required this.onCancel,
  });

  final String bookingId;
  final bool isCancelling;
  final ValueChanged<Booking> onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(bookingDetailsProvider(bookingId));

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: details.when(
          loading: () => const SizedBox(
            height: 220,
            child: Center(child: AppHashLoader()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(18),
            child: AsyncErrorView(
              error: error,
              onRetry: () => ref.invalidate(bookingDetailsProvider(bookingId)),
            ),
          ),
          data: (booking) => _BookingDetailContent(
            booking: booking,
            isCancelling: isCancelling,
            onCancel: onCancel,
          ),
        ),
      ),
    );
  }
}

class _BookingDetailContent extends ConsumerWidget {
  const _BookingDetailContent({
    required this.booking,
    required this.isCancelling,
    required this.onCancel,
  });

  final Booking booking;
  final bool isCancelling;
  final ValueChanged<Booking> onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final movie = booking.showtime.movie;
    final theater = booking.showtime.theater;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Chi tiết booking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 82,
                height: 116,
                child: NetworkImageCard(
                  imageUrl: movie?.imageUrl,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie?.title ?? 'Vé xem phim',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _BookingStatusPill(status: booking.status),
                    const SizedBox(height: 10),
                    _MovieMetaLine(
                      icon: Icons.location_on_outlined,
                      label: theater?.name ?? 'Rạp chiếu',
                    ),
                    const SizedBox(height: 4),
                    _MovieMetaLine(
                      icon: Icons.meeting_room_outlined,
                      label: booking.showtime.screenName,
                    ),
                    const SizedBox(height: 4),
                    _MovieMetaLine(
                      icon: Icons.schedule_rounded,
                      label: DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(booking.showtime.startTime),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailRow(label: 'Mã booking', value: '#${booking.id}'),
          _DetailRow(label: 'Ghế', value: booking.seatNumbers.join(', ')),
          _DetailRow(label: 'Tiền vé', value: _money(booking.ticketFinalTotal)),
          if (booking.services.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Bắp nước',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            ...booking.services.map(
              (service) => _DetailRow(
                label: '${service.name} x${service.quantity}',
                value: _money(service.finalTotal),
              ),
            ),
          ],
          if (booking.pointsUsed > 0)
            _DetailRow(label: 'Điểm sử dụng', value: '-${booking.pointsUsed}'),
          const SizedBox(height: 8),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.45)),
          _DetailRow(
            label: 'Tổng thanh toán',
            value: _money(booking.payableTotal),
            emphasized: true,
          ),
          if (booking.isPending) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: isCancelling
                  ? null
                  : () {
                      Navigator.pop(context);
                      onCancel(booking);
                    },
              icon: isCancelling
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: const Text('Hủy vé'),
            ),
          ],
          if (booking.status == 'CONFIRMED') ...[
            const SizedBox(height: 12),
            _RefundActionButton(booking: booking),
          ],
        ],
      ),
    );
  }
}

class _RefundActionButton extends ConsumerWidget {
  const _RefundActionButton({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refund = booking.refundRequest;

    if (refund != null) {
      return OutlinedButton.icon(
        onPressed: () => _showRefundDetail(context, ref, refund),
        icon: const Icon(Icons.receipt_long_outlined),
        label: const Text('Xem yêu cầu hoàn tiền'),
      );
    }

    if (!booking.canRequestRefund) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: () => _showCreateRefundDialog(context, ref, booking),
      icon: const Icon(Icons.currency_exchange),
      label: const Text('Yêu cầu hoàn tiền'),
    );
  }

  Future<void> _showCreateRefundDialog(
    BuildContext context,
    WidgetRef ref,
    Booking booking,
  ) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu hoàn tiền'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Lý do',
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Gửi yêu cầu'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (!context.mounted || reason == null) return;
    if (reason.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập lý do ít nhất 5 ký tự.')),
      );
      return;
    }

    try {
      await ref
          .read(bookingRepositoryProvider)
          .createRefundRequest(bookingId: booking.id, reason: reason);
      ref
        ..invalidate(bookingDetailsProvider(booking.id))
        ..invalidate(bookingHistoryProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi yêu cầu hoàn tiền.')),
      );
    } catch (error) {
      if (context.mounted) showAppErrorSnackBar(context, error);
    }
  }

  Future<void> _showRefundDetail(
    BuildContext context,
    WidgetRef ref,
    RefundRequest refund,
  ) async {
    final cancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu hoàn tiền'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Trạng thái: ${_refundStatusText(refund.status)}'),
            const SizedBox(height: 8),
            Text('Số tiền: ${_money(refund.refundAmount)}'),
            const SizedBox(height: 8),
            Text('Lý do: ${refund.reason}'),
            if (refund.response?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text('Phản hồi: ${refund.response}'),
            ],
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Đóng'),
          ),
          if (refund.isPending)
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hủy yêu cầu'),
            ),
        ],
      ),
    );

    if (cancel != true || !context.mounted) return;

    try {
      await ref.read(bookingRepositoryProvider).cancelRefundRequest(refund.id);
      ref
        ..invalidate(bookingDetailsProvider(booking.id))
        ..invalidate(bookingHistoryProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã hủy yêu cầu hoàn tiền.')),
      );
    } catch (error) {
      if (context.mounted) showAppErrorSnackBar(context, error);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: emphasized ? colorScheme.primary : null,
                fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingStatusPill extends StatelessWidget {
  const _BookingStatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'PENDING' => Colors.orange,
      'CONFIRMED' => Colors.green,
      'CANCELLED' => Theme.of(context).colorScheme.error,
      'REFUNDED' => Colors.teal,
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
          switch (status) {
            'PENDING' => 'Sắp chiếu',
            'CONFIRMED' => 'Đã xem',
            'CANCELLED' => 'Đã hủy',
            'REFUNDED' => 'Hoàn tiền',
            _ => status,
          },
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
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

class _WaitlistSection extends ConsumerWidget {
  const _WaitlistSection({
    required this.removingMovieIds,
    required this.onRemove,
  });

  final Set<String> removingMovieIds;
  final ValueChanged<WaitlistItem> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitlist = ref.watch(waitlistProvider);

    return waitlist.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: AppHashLoader()),
      ),
      error: (error, _) => AsyncErrorView(
        error: error,
        onRetry: () => ref.invalidate(waitlistProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyWaitlist();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _WaitlistMovieCard(
                    item: item,
                    isRemoving: removingMovieIds.contains(item.movie.id),
                    onRemove: () => onRemove(item),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _EmptyWaitlist extends StatelessWidget {
  const _EmptyWaitlist();

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
          Icon(
            Icons.bookmark_border_rounded,
            size: 42,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có phim trong danh sách chờ',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Các phim sắp chiếu bạn lưu sẽ xuất hiện tại đây.',
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

class _WaitlistMovieCard extends StatelessWidget {
  const _WaitlistMovieCard({
    required this.item,
    required this.isRemoving,
    required this.onRemove,
  });

  final WaitlistItem item;
  final bool isRemoving;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final movie = item.movie;
    final genres = movie.genres
        .map((genre) => genre.name)
        .where((name) => name.trim().isNotEmpty)
        .take(2)
        .join(' • ');

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutePaths.movie(movie.id)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 76,
                height: 108,
                child: NetworkImageCard(
                  imageUrl: movie.image?.url,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _MovieMetaLine(
                      icon: Icons.event_available_outlined,
                      label: _formatWaitlistDate(movie.releaseDate),
                    ),
                    const SizedBox(height: 4),
                    _MovieMetaLine(
                      icon: Icons.schedule_rounded,
                      label: movie.duration > 0
                          ? '${movie.duration} phút • ${movie.ageRating}'
                          : movie.ageRating,
                    ),
                    if (genres.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _MovieMetaLine(
                        icon: Icons.local_movies_outlined,
                        label: genres,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 34,
                        child: OutlinedButton.icon(
                          onPressed: isRemoving ? null : onRemove,
                          icon: isRemoving
                              ? const SizedBox.square(
                                  dimension: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.bookmark_remove_outlined,
                                  size: 18,
                                ),
                          label: const Text('Xoá'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatWaitlistDate(DateTime? value) {
    if (value == null) return 'Chưa cập nhật ngày chiếu';
    return 'Khởi chiếu ${DateFormat('dd/MM/yyyy').format(value)}';
  }
}

class _MovieMetaLine extends StatelessWidget {
  const _MovieMetaLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: <Widget>[
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
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

String _shortBookingCode(String id) {
  if (id.length <= 10) return id;
  return id.substring(id.length - 10);
}

String _refundStatusText(String status) => switch (status) {
  'PENDING' => 'Chờ xử lý',
  'APPROVED' => 'Đã hoàn tiền',
  'REJECTED' => 'Đã từ chối',
  'CANCELLED' => 'Đã hủy',
  _ => status,
};

String _money(num value) =>
    NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(value);
