import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';

class ServiceSelectionPage extends ConsumerStatefulWidget {
  const ServiceSelectionPage({super.key});
  @override
  ConsumerState<ServiceSelectionPage> createState() =>
      _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends ConsumerState<ServiceSelectionPage>
    with WidgetsBindingObserver {
  final Map<String, int> _quantities = <String, int>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshServices();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftControllerProvider);
    if (draft == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            'Phiên chọn ghế không còn hiệu lực. Vui lòng chọn lại suất chiếu.',
          ),
        ),
      );
    }
    final services = ref.watch(
      cinemaServicesProvider(draft.seating.theater.id),
    );
    final submitting = ref.watch(bookingCheckoutControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Bắp nước & dịch vụ')),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(draft.seating.movie.title, maxLines: 1),
            subtitle: Text(
              '${draft.seating.theater.name} • ${draft.selectedSeats.map((seat) => seat.number).join(', ')}',
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: services.when(
              loading: () => const Center(child: AppHashLoader()),
              error: (error, _) => AsyncErrorView(
                error: error,
                onRetry: () => ref.invalidate(
                  cinemaServicesProvider(draft.seating.theater.id),
                ),
              ),
              data: (items) => items.isEmpty
                  ? const Center(
                      child: Text(
                        'Rạp chưa có dịch vụ. Bạn có thể tiếp tục thanh toán.',
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 24),
                      itemBuilder: (context, index) => _ServiceTile(
                        service: items[index],
                        quantity: (_quantities[items[index].id] ?? 0).clamp(
                          0,
                          items[index].quantity,
                        ),
                        onChanged: (value) => setState(() {
                          if (value == 0) {
                            _quantities.remove(items[index].id);
                          } else {
                            _quantities[items[index].id] = value;
                          }
                        }),
                      ),
                    ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Tạm tính',
                          style: TextStyle(color: Colors.white60),
                        ),
                        services.maybeWhen(
                          data: (items) => Text(
                            _money(
                              draft.ticketTotal + _concessionAmount(items),
                            ),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          orElse: () => Text(_money(draft.ticketTotal)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: GradientButton(
                      label: 'Tạo đơn',
                      isLoading: submitting,
                      onPressed: submitting ? null : _checkout,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _concessionAmount(List<CinemaService> items) => items.fold(
    0,
    (sum, item) => sum + item.price * (_quantities[item.id] ?? 0),
  );

  Future<void> _checkout() async {
    try {
      final draft = ref.read(bookingDraftControllerProvider);
      if (draft == null) return;
      final services = await ref.read(
        cinemaServicesProvider(draft.seating.theater.id).future,
      );
      if (!mounted || !_reconcileQuantities(services)) return;

      final pending = await ref.read(pendingBookingControllerProvider.future);
      if (!mounted) return;
      if (pending.isActive) {
        await _showPending(pending);
        return;
      }

      final booking = await ref
          .read(bookingCheckoutControllerProvider.notifier)
          .create(_quantities);
      if (booking != null && mounted) {
        await context.push(AppRoutePaths.payment(booking.id));
        if (mounted) _refreshServices();
      }
    } catch (error) {
      if (!mounted) return;
      showAppErrorSnackBar(context, error);
      await ref.read(pendingBookingControllerProvider.notifier).refresh();
    }
  }

  Future<void> _showPending(PendingBookingState pending) async {
    final resume = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đơn hàng đang chờ thanh toán'),
        content: Text(
          'Bạn không thể tạo đơn mới trong ${pending.formattedTime} còn lại.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Đóng'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Thanh toán'),
          ),
        ],
      ),
    );
    if (resume == true && mounted) {
      await context.push(AppRoutePaths.payment(pending.booking!.id));
      if (mounted) _refreshServices();
    }
  }

  bool _reconcileQuantities(List<CinemaService> services) {
    final byId = <String, CinemaService>{
      for (final service in services) service.id: service,
    };
    var changed = false;
    final reconciled = <String, int>{};
    for (final entry in _quantities.entries) {
      final service = byId[entry.key];
      if (service == null) {
        changed = true;
        continue;
      }
      final quantity = entry.value.clamp(0, service.quantity);
      if (quantity != entry.value) changed = true;
      if (quantity > 0) reconciled[entry.key] = quantity;
    }
    if (!changed) return true;

    setState(() {
      _quantities
        ..clear()
        ..addAll(reconciled);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Số lượng dịch vụ đã thay đổi. Vui lòng kiểm tra lại.'),
        ),
      );
    return false;
  }

  void _refreshServices() {
    final draft = ref.read(bookingDraftControllerProvider);
    if (draft == null) return;
    ref.invalidate(cinemaServicesProvider(draft.seating.theater.id));
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.quantity,
    required this.onChanged,
  });
  final CinemaService service;
  final int quantity;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 72,
          height: 72,
          child: service.imageUrl?.isNotEmpty == true
              ? CachedNetworkImage(
                  imageUrl: service.imageUrl!,
                  fit: BoxFit.cover,
                )
              : const ColoredBox(
                  color: Color(0xFF1C1C24),
                  child: Icon(Icons.fastfood_outlined),
                ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              service.name,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            if (service.description.isNotEmpty)
              Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            const SizedBox(height: 4),
            Text(
              _money(service.price),
              style: const TextStyle(
                color: Color(0xFFFF7777),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      Row(
        children: <Widget>[
          IconButton(
            onPressed: quantity > 0 ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          IconButton(
            onPressed: quantity < service.quantity
                ? () => onChanged(quantity + 1)
                : null,
            icon: const Icon(Icons.add_circle, color: Color(0xFFE30713)),
          ),
        ],
      ),
    ],
  );
}

String _money(num value) => NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
).format(value);
