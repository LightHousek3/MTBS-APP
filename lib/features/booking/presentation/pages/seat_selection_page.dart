import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/presentation/booking_navigation.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';

class SeatSelectionPage extends ConsumerStatefulWidget {
  const SeatSelectionPage({required this.showtimeId, super.key});
  final String showtimeId;
  @override
  ConsumerState<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage>
    with WidgetsBindingObserver {
  final Set<String> _selectedIds = <String>{};
  bool _checkingPending = false;

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
    if (state == AppLifecycleState.resumed) {
      _refreshSeating();
    }
  }

  @override
  void didUpdateWidget(covariant SeatSelectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showtimeId != widget.showtimeId) {
      _selectedIds.clear();
      ref.invalidate(seatingProvider(widget.showtimeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final seating = ref.watch(seatingProvider(widget.showtimeId));
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn ghế')),
      body: seating.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) =>
            AsyncErrorView(error: error, onRetry: _refreshSeating),
        data: _content,
      ),
    );
  }

  Widget _content(SeatingData data) {
    final selected = data.seats
        .where((seat) => seat.isAvailable && _selectedIds.contains(seat.id))
        .toList();
    final selectedPricing = data.priceForSeats(selected);
    final rows = <String, List<CinemaSeat>>{};
    for (final seat in data.seats) {
      final row =
          RegExp(r'^[A-Za-z]+').firstMatch(seat.number)?.group(0) ?? 'A';
      rows.putIfAbsent(row, () => <CinemaSeat>[]).add(seat);
    }
    final entries = rows.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    for (final entry in entries) {
      entry.value.sort(
        (a, b) => _seatNumber(a.number).compareTo(_seatNumber(b.number)),
      );
    }
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(data.movie.title, maxLines: 1),
              subtitle: Text(
                '${data.theater.name} • ${data.screenName} • ${DateFormat('HH:mm').format(data.showtime.startTime)}',
                style: const TextStyle(color: Colors.white60),
              ),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 22, 12, 18),
            child: Column(
              children: <Widget>[
                for (final row in entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 22,
                          child: Text(row.key, textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: row.value
                                    .map(
                                      (seat) => _SeatButton(
                                        seat: seat,
                                        selected: _selectedIds.contains(
                                          seat.id,
                                        ),
                                        onTap: () =>
                                            unawaited(_toggleSeat(seat)),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 22,
                          child: Text(row.key, textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 26),
                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 34),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Colors.white38, blurRadius: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MÀN HÌNH',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 22),
                const _SeatLegend(),
              ],
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
                      Text(
                        selected.isEmpty
                            ? 'Chưa chọn ghế'
                            : '${selected.length} ghế: ${selected.map((seat) => seat.number).join(', ')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white60),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _SeatPrice(
                          key: ValueKey<String>(
                            '${selectedPricing.base}-${selectedPricing.finalPrice}',
                          ),
                          pricing: selectedPricing,
                        ),
                      ),
                      const Text(
                        'Tổng giá vé',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GradientButton(
                    label: 'Tiếp tục',
                    onPressed: selected.isEmpty
                        ? null
                        : () => unawaited(_openServices(selected)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleSeat(CinemaSeat seat) async {
    if (!seat.isAvailable) return;
    if (_selectedIds.contains(seat.id)) {
      setState(() => _selectedIds.remove(seat.id));
      return;
    }

    if (_checkingPending) return;
    _checkingPending = true;
    try {
      final canSelect = await canSelectNewSeat(context, ref);
      if (!canSelect || !mounted) return;
      setState(() => _selectedIds.add(seat.id));
    } finally {
      _checkingPending = false;
    }
  }

  Future<void> _openServices(List<CinemaSeat> selectedSeats) async {
    final selectedIds = selectedSeats.map((seat) => seat.id).toSet();
    ref.invalidate(seatingProvider(widget.showtimeId));
    final freshSeating = await ref.read(
      seatingProvider(widget.showtimeId).future,
    );
    if (!mounted) return;

    final freshSelectedSeats = freshSeating.seats
        .where((seat) => seat.isAvailable && selectedIds.contains(seat.id))
        .toList(growable: false);
    if (freshSelectedSeats.length != selectedIds.length) {
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(freshSelectedSeats.map((seat) => seat.id));
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Trạng thái ghế vừa thay đổi. Vui lòng kiểm tra và chọn lại.',
            ),
          ),
        );
      return;
    }

    ref
        .read(bookingDraftControllerProvider.notifier)
        .setDraft(freshSeating, freshSelectedSeats);
    await context.push(AppRoutePaths.services);
    if (mounted) _refreshSeating();
  }

  void _refreshSeating() {
    if (mounted && _selectedIds.isNotEmpty) {
      setState(_selectedIds.clear);
    }
    ref.invalidate(seatingProvider(widget.showtimeId));
  }
}

class _SeatPrice extends StatelessWidget {
  const _SeatPrice({required this.pricing, super.key});
  final PriceSummary pricing;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      if (pricing.hasDiscount) ...<Widget>[
        Text(
          _money(pricing.base),
          style: const TextStyle(
            color: Colors.white54,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 8),
      ],
      Text(
        _money(pricing.finalPrice),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: pricing.hasDiscount ? const Color(0xFFFF7777) : null,
        ),
      ),
    ],
  );
}

class _SeatButton extends StatelessWidget {
  const _SeatButton({
    required this.seat,
    required this.selected,
    required this.onTap,
  });
  final CinemaSeat seat;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final typeColor = seat.type == 'VIP'
        ? const Color(0xFFFFB020)
        : seat.type == 'SWEETBOX'
        ? const Color(0xFF4E8EF7)
        : Colors.white70;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: seat.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: seat.type == 'SWEETBOX' ? 55 : 25,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: !seat.isAvailable
                ? Colors.white24
                : selected
                ? const Color(0xFFE30713)
                : Colors.transparent,
            border: Border.all(
              color: !seat.isAvailable
                  ? Colors.transparent
                  : selected
                  ? const Color(0xFFFF7777)
                  : typeColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            seat.number.replaceAll(RegExp(r'\D'), ''),
            style: const TextStyle(fontSize: 9),
          ),
        ),
      ),
    );
  }
}

class _SeatLegend extends StatelessWidget {
  const _SeatLegend();
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 16,
    runSpacing: 10,
    alignment: WrapAlignment.center,
    children: <Widget>[
      _Legend(color: Colors.white70, label: 'Thường'),
      _Legend(color: Color(0xFFFFB020), label: 'VIP'),
      _Legend(color: Color(0xFF4E8EF7), label: 'Ghế đôi'),
      _Legend(color: Color(0xFFE30713), label: 'Đang chọn'),
      _Legend(color: Colors.white24, label: 'Đã giữ'),
    ],
  );
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.white60)),
    ],
  );
}

int _seatNumber(String value) =>
    int.tryParse(value.replaceAll(RegExp(r'\D'), '')) ?? 0;
String _money(num value) => NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
).format(value);
