import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({required this.bookingId, this.initialResult, super.key});

  final String bookingId;
  final PaymentPageResultData? initialResult;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  Uri? _paymentUri;
  String _paymentTitle = 'Thanh toán';
  bool _startingPayment = false;
  bool _handlingPaymentReturn = false;
  bool _webViewLoading = false;
  String? _lastHandledResultKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_consumeIncomingResult(widget.initialResult));
    });
  }

  @override
  void didUpdateWidget(covariant PaymentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialResult != widget.initialResult) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_consumeIncomingResult(widget.initialResult));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_paymentUri case final paymentUri?) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            unawaited(_closePaymentWebView());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _closePaymentWebView,
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(_paymentTitle),
          ),
          body: Stack(
            children: <Widget>[
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri.uri(paymentUri)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  supportZoom: false,
                  transparentBackground: false,
                ),
                onLoadStart: (_, url) {
                  if (_tryHandlePaymentUri(url)) {
                    return;
                  }
                  if (mounted) {
                    setState(() => _webViewLoading = true);
                  }
                },
                onLoadStop: (_, url) {
                  if (_tryHandlePaymentUri(url)) {
                    return;
                  }
                  if (mounted) {
                    setState(() => _webViewLoading = false);
                  }
                },
                shouldOverrideUrlLoading: (_, action) async {
                  if (_tryHandlePaymentUri(action.request.url)) {
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedServerTrustAuthRequest: (_, challenge) async {
                  final host = challenge.protectionSpace.host.toLowerCase();
                  if (_isTrustedVnpayHost(host)) {
                    return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED,
                    );
                  }

                  return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.CANCEL,
                  );
                },
                onReceivedError: (_, request, error) {
                  if (request.isForMainFrame == false) {
                    return;
                  }
                  unawaited(_handleWebViewError(error.description));
                },
              ),
              if (_webViewLoading) const Center(child: AppHashLoader()),
            ],
          ),
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
                          '${DateFormat('HH:mm - dd/MM/yyyy').format(booking.showtime.startTime)} '
                          '• ${booking.showtime.screenName}',
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
                basePrice: booking.movieBaseTotal,
                finalPrice: booking.ticketFinalTotal,
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
                  _ServicePriceLine(service: service),
              _priceLine(
                'Tổng giá dịch vụ',
                basePrice: booking.serviceBaseTotal,
                finalPrice: booking.concessionFinalTotal,
                strong: true,
              ),
              if (booking.pointsUsed > 0)
                _plainLine('Điểm đã dùng', '-${booking.pointsUsed} điểm'),
              const Divider(height: 28),
              _priceLine(
                'Tổng cộng',
                basePrice: booking.baseTotal,
                finalPrice: booking.payableTotal,
                strong: true,
              ),
              if (booking.pointsEarned > 0)
                _plainLine('Điểm nhận được', '+${booking.pointsEarned} điểm'),
              if (booking.status == 'CONFIRMED' &&
                  booking.qrCode?.isNotEmpty == true) ...<Widget>[
                const Divider(height: 30),
                Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Mã QR vé',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      _BookingQrCode(dataUri: booking.qrCode!),
                    ],
                  ),
                ),
              ],
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
            onPressed: _startingPayment ? null : () => _pay('vnpay'),
          ),
          const SizedBox(height: 10),
          GradientButton(
            label: 'Thanh toán ATM nội địa qua MoMo',
            icon: const Icon(Icons.account_balance, color: Colors.white),
            isLoading: _startingPayment,
            onPressed: _startingPayment ? null : () => _pay('momo'),
          ),
          const SizedBox(height: 10),
          GradientButton(
            label: 'Thanh toán ATM nội địa qua ZaloPay',
            icon: const Icon(Icons.account_balance, color: Colors.white),
            isLoading: _startingPayment,
            onPressed: _startingPayment ? null : () => _pay('zalopay'),
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
        if (booking.status == 'CONFIRMED') ...<Widget>[
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutePaths.accountBookingHistory()),
            icon: const Icon(Icons.history),
            label: const Text('Xem lịch sử vé'),
          ),
        ],
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

  Widget _plainLine(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white60)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );

  Future<void> _pay(String method) async {
    setState(() => _startingPayment = true);
    try {
      final url = await ref
          .read(bookingRepositoryProvider)
          .createPaymentUrl(widget.bookingId, method: method);
      final paymentUri = Uri.parse(url);
      if (mounted) {
        setState(() {
          _paymentUri = paymentUri;
          _paymentTitle = 'Thanh toán ${_paymentMethodLabel(method)}';
          _startingPayment = false;
          _webViewLoading = true;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _startingPayment = false);
        showAppErrorSnackBar(context, error);
      }
    }
  }

  Future<void> _consumeIncomingResult(PaymentPageResultData? result) async {
    if (!mounted || result == null || _handlingPaymentReturn) {
      return;
    }

    final resultKey = result.identityKey;
    if (_lastHandledResultKey == resultKey) {
      return;
    }
    _lastHandledResultKey = resultKey;

    await _handlePaymentReturn(result.toUri());
  }

  Future<void> _handlePaymentReturn(Uri uri) async {
    if (!mounted || _handlingPaymentReturn) {
      return;
    }
    _handlingPaymentReturn = true;

    try {
      setState(() {
        _paymentUri = null;
        _webViewLoading = false;
      });

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
      if (!mounted) {
        return;
      }

      final message = latestBooking.status == 'CONFIRMED'
          ? 'Thanh toán thành công.'
          : callbackSucceeded
          ? 'Giao dịch đang được xác nhận. Vui lòng kiểm tra lại sau ít phút.'
          : uri.queryParameters['message'] ?? 'Thanh toán chưa thành công.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (mounted) {
        showAppErrorSnackBar(context, error);
      }
    } finally {
      _handlingPaymentReturn = false;
    }
  }

  Future<void> _handleWebViewError(String description) async {
    if (!mounted || _handlingPaymentReturn) {
      return;
    }
    _handlingPaymentReturn = true;

    try {
      setState(() {
        _paymentUri = null;
        _webViewLoading = false;
      });

      final latestBooking = await _pollBookingStatus(
        waitForConfirmation: true,
        maxAttempts: 8,
      );
      await ref.read(pendingBookingControllerProvider.notifier).refresh();
      if (!mounted) {
        return;
      }

      final message = latestBooking.status == 'CONFIRMED'
          ? 'Thanh toán thành công.'
          : 'Không thể tải cổng thanh toán. Vui lòng thử lại.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (mounted) {
        showAppErrorSnackBar(context, description);
      }
    } finally {
      _handlingPaymentReturn = false;
    }
  }

  Future<Booking> _pollBookingStatus({
    required bool waitForConfirmation,
    int maxAttempts = 5,
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      ref.invalidate(bookingDetailsProvider(widget.bookingId));
      final booking = await ref.read(
        bookingDetailsProvider(widget.bookingId).future,
      );

      final shouldStop =
          !waitForConfirmation ||
          booking.status != 'PENDING' ||
          attempt == maxAttempts - 1;
      if (shouldStop) {
        return booking;
      }

      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) {
        return booking;
      }
    }

    throw StateError('Không thể đồng bộ trạng thái thanh toán.');
  }

  Future<void> _closePaymentWebView() async {
    if (!mounted || _paymentUri == null) {
      return;
    }
    setState(() {
      _paymentUri = null;
      _webViewLoading = false;
    });
    try {
      ref.invalidate(bookingDetailsProvider(widget.bookingId));
      await ref.read(pendingBookingControllerProvider.notifier).refresh();
    } catch (error) {
      if (mounted) {
        showAppErrorSnackBar(context, error);
      }
    }
  }

  bool _tryHandlePaymentUri(Uri? uri) {
    if (uri == null) {
      return false;
    }
    if (uri.scheme == 'mtbs' &&
        uri.host.isEmpty &&
        uri.path == '/payment-result') {
      unawaited(_handlePaymentReturn(uri));
      return true;
    }
    return false;
  }

  bool _isTrustedVnpayHost(String host) =>
      host == 'sandbox.vnpayment.vn' ||
      host.endsWith('.vnpayment.vn') ||
      host == 'test-payment.momo.vn' ||
      host.endsWith('.momo.vn') ||
      host == 'sb-openapi.zalopay.vn' ||
      host.endsWith('.zalopay.vn');

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
    if (confirmed != true) {
      return;
    }
    try {
      await ref
          .read(pendingBookingControllerProvider.notifier)
          .cancel(widget.bookingId);
      if (mounted) {
        context.go(AppRoutePaths.home);
      }
    } catch (error) {
      if (mounted) {
        showAppErrorSnackBar(context, error);
      }
    }
  }
}

String _paymentMethodLabel(String method) => switch (method) {
  'momo' => 'MoMo',
  'zalopay' => 'ZaloPay',
  _ => 'VNPay',
};

class _ServicePriceLine extends StatelessWidget {
  const _ServicePriceLine({required this.service});

  final BookingServiceLine service;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${service.name} × ${service.quantity}',
                style: const TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 2),
              Text(
                'Đơn giá: ${_money(service.unitPrice)}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
        if (service.finalTotal < service.baseTotal) ...<Widget>[
          Text(
            _money(service.baseTotal),
            style: const TextStyle(
              color: Colors.white54,
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          _money(service.finalTotal),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: service.finalTotal < service.baseTotal
                ? const Color(0xFFFF7777)
                : null,
          ),
        ),
      ],
    ),
  );
}

class _BookingQrCode extends StatelessWidget {
  const _BookingQrCode({required this.dataUri});

  final String dataUri;

  @override
  Widget build(BuildContext context) {
    final commaIndex = dataUri.indexOf(',');
    if (!dataUri.startsWith('data:image') || commaIndex == -1) {
      return SelectableText(
        dataUri,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.memory(
        base64Decode(dataUri.substring(commaIndex + 1)),
        width: 180,
        height: 180,
        fit: BoxFit.contain,
      ),
    );
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

class PaymentPageResultData {
  const PaymentPageResultData({
    required this.bookingId,
    this.success,
    this.status,
    this.message,
  });

  final String bookingId;
  final bool? success;
  final String? status;
  final String? message;

  String get identityKey =>
      '$bookingId|${success?.toString() ?? ''}|${status ?? ''}|${message ?? ''}';

  Uri toUri() => Uri(
    scheme: 'mtbs',
    path: '/payment-result',
    queryParameters: <String, String>{
      'bookingId': bookingId,
      if (success != null) 'success': success.toString(),
      if (status != null && status!.isNotEmpty) 'status': status!,
      if (message != null && message!.isNotEmpty) 'message': message!,
    },
  );

  static PaymentPageResultData? fromQueryParameters(
    Map<String, String> queryParameters,
  ) {
    final bookingId = queryParameters['bookingId'];
    if (bookingId == null || bookingId.isEmpty) {
      return null;
    }

    final rawSuccess = queryParameters['success'];
    return PaymentPageResultData(
      bookingId: bookingId,
      success: rawSuccess == null ? null : rawSuccess.toLowerCase() == 'true',
      status: queryParameters['status'],
      message: queryParameters['message'],
    );
  }
}
