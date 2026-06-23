import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({required this.bookingId, super.key});
  final String bookingId;
  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  WebViewController? _webView;
  bool _startingPayment = false;
  bool _handlingPaymentReturn = false;

  @override
  Widget build(BuildContext context) {
    if (_webView case final controller?) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(_closePaymentWebView());
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _closePaymentWebView,
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Thanh toán VNPay'),
          ),
          body: WebViewWidget(controller: controller),
        ),
      );
    }
    final details = ref.watch(bookingDetailsProvider(widget.bookingId));
    final pending =
        ref.watch(pendingBookingControllerProvider).value ??
        const PendingBookingState();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutePaths.home),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Thanh toán'),
      ),
      body: details.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () =>
              ref.invalidate(bookingDetailsProvider(widget.bookingId)),
        ),
        data: (booking) => _summary(booking, pending),
      ),
    );
  }

  Widget _summary(Booking booking, PendingBookingState pending) {
    final active = booking.isPending && pending.secondsLeft > 0;
    return ListView(
      padding: const EdgeInsets.all(18),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF16181E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.timer_outlined, color: Color(0xFFFF7777)),
                  const SizedBox(width: 8),
                  Text(
                    active
                        ? 'Giữ ghế còn ${pending.formattedTime}'
                        : _statusText(booking.status),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF7777),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 88,
                    height: 124,
                    child: NetworkImageCard(
                      imageUrl: booking.showtime.movie?.imageUrl,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          booking.showtime.movie?.title ?? 'Vé xem phim',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking.showtime.theater?.name ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('HH:mm - dd/MM/yyyy').format(booking.showtime.startTime)} • ${booking.showtime.screenName}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              Text('Giá vé', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final seat in booking.seats)
                _priceLine(
                  'Ghế ${seat.number}',
                  basePrice: seat.basePrice,
                  finalPrice: seat.finalPrice,
                ),
              _priceLine(
                'Tổng giá vé',
                basePrice: booking.seatTotal,
                finalPrice: booking.seatFinalTotal,
                strong: true,
              ),
              const Divider(height: 26),
              Text(
                'Giá dịch vụ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (booking.services.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Không chọn dịch vụ',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              else
                for (final service in booking.services)
                  _priceLine(
                    '${service.name} × ${service.quantity}',
                    basePrice: service.baseTotal,
                    finalPrice: service.finalTotal,
                  ),
              _priceLine(
                'Tổng giá dịch vụ',
                basePrice: booking.serviceTotal,
                finalPrice: booking.serviceFinalTotal,
                strong: true,
              ),
              const Divider(height: 28),
              _priceLine(
                'Tổng cộng',
                basePrice: booking.baseTotal,
                finalPrice: booking.totalPrice,
                strong: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (active) ...<Widget>[
          GradientButton(
            label: 'Thanh toán qua VNPay',
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
            ),
            isLoading: _startingPayment,
            onPressed: _startingPayment ? null : _pay,
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _cancel, child: const Text('Hủy đơn hàng')),
        ] else
          Center(
            child: Text(
              booking.status == 'CONFIRMED'
                  ? 'Thanh toán thành công'
                  : 'Đơn hàng không còn hiệu lực.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  Widget _priceLine(
    String label, {
    required double basePrice,
    required double finalPrice,
    bool strong = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? Colors.white : Colors.white60,
              fontWeight: strong ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ),
        if (finalPrice < basePrice) ...<Widget>[
          Text(
            _money(basePrice),
            style: TextStyle(
              color: Colors.white54,
              decoration: TextDecoration.lineThrough,
              fontSize: strong ? 14 : 12,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          _money(finalPrice),
          style: TextStyle(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w600,
            fontSize: strong ? 18 : 14,
            color: finalPrice < basePrice ? const Color(0xFFFF7777) : null,
          ),
        ),
      ],
    ),
  );

  Future<void> _pay() async {
    setState(() => _startingPayment = true);
    try {
      final url = await ref.read(paymentUrlProvider(widget.bookingId).future);
      final controller = WebViewController();
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri?.scheme == 'mtbs') {
              unawaited(_handlePaymentReturn(uri!));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
      await controller.loadRequest(Uri.parse(url));
      if (mounted) {
        setState(() {
          _webView = controller;
          _startingPayment = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _startingPayment = false);
        showAppErrorSnackBar(context, error);
      }
    }
  }

  Future<void> _handlePaymentReturn(Uri uri) async {
    if (!mounted || _handlingPaymentReturn) return;
    _handlingPaymentReturn = true;

    try {
      setState(() => _webView = null);

      final returnedBookingId = uri.queryParameters['bookingId'];
      if (returnedBookingId != null && returnedBookingId != widget.bookingId) {
        showAppErrorSnackBar(
          context,
          'Kết quả thanh toán không thuộc đơn hàng hiện tại.',
        );
        return;
      }

      final callbackSucceeded = uri.queryParameters['success'] == 'true';
      final latestBooking = await _pollBookingStatus(
        waitForConfirmation: callbackSucceeded,
      );

      await ref.read(pendingBookingControllerProvider.notifier).refresh();
      if (!mounted) return;

      final message = latestBooking.status == 'CONFIRMED'
          ? 'Thanh toán thành công.'
          : callbackSucceeded
          ? 'Giao dịch đang được xác nhận. Vui lòng kiểm tra lại sau ít phút.'
          : uri.queryParameters['message'] ?? 'Thanh toán chưa thành công.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      _handlingPaymentReturn = false;
    }
  }

  Future<Booking> _pollBookingStatus({
    required bool waitForConfirmation,
  }) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      ref.invalidate(bookingDetailsProvider(widget.bookingId));
      final booking = await ref.read(
        bookingDetailsProvider(widget.bookingId).future,
      );

      final shouldStop =
          !waitForConfirmation || booking.status != 'PENDING' || attempt == 4;
      if (shouldStop) return booking;

      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return booking;
    }

    throw StateError('Không thể đồng bộ trạng thái thanh toán.');
  }

  Future<void> _closePaymentWebView() async {
    if (!mounted || _webView == null) return;
    setState(() => _webView = null);
    try {
      ref.invalidate(bookingDetailsProvider(widget.bookingId));
      await ref.read(pendingBookingControllerProvider.notifier).refresh();
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    }
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng?'),
        content: const Text('Ghế đang giữ sẽ được trả lại ngay.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(pendingBookingControllerProvider.notifier)
          .cancel(widget.bookingId);
      if (mounted) context.go(AppRoutePaths.home);
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    }
  }
}

String _statusText(String status) => status == 'CONFIRMED'
    ? 'Đã thanh toán'
    : status == 'CANCELLED'
    ? 'Đã hủy'
    : 'Đã hết hạn';
String _money(num value) => NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
).format(value);
