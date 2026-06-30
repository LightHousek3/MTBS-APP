import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';

Future<void> startBookingFlow(
  BuildContext context,
  WidgetRef ref,
  String showtimeId,
) async {
  final seatRoute = AppRoutePaths.seats(showtimeId);
  final isAuthenticated = await _ensureAuthenticated(
    context,
    ref,
    redirectAfterLogin: seatRoute,
  );
  if (!isAuthenticated || !context.mounted) return;

  ref.invalidate(seatingProvider(showtimeId));
  await context.push(seatRoute);
}

Future<bool> _ensureAuthenticated(
  BuildContext context,
  WidgetRef ref, {
  required String redirectAfterLogin,
}) async {
  final authState = ref.read(authControllerProvider);
  final currentUser = switch (authState) {
    AsyncData(:final value) => value,
    _ => null,
  };
  if (currentUser != null) return true;

  if (authState.isLoading) {
    final restoredUser = await ref
        .read(authControllerProvider.future)
        .catchError((_) => null);
    if (!context.mounted) return false;
    if (restoredUser != null) return true;
  }

  await context.push(AppRoutePaths.loginFrom(redirectAfterLogin));
  return false;
}

Future<bool> canSelectNewSeat(BuildContext context, WidgetRef ref) async {
  final pending = await ref.read(pendingBookingControllerProvider.future);
  if (!context.mounted || !pending.isActive) return context.mounted;

  final resume = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bạn đang có đơn chờ thanh toán'),
      content: Text(
        'Hoàn tất đơn hiện tại trong ${pending.formattedTime} trước khi đặt vé mới.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Đóng'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Thanh toán ngay'),
        ),
      ],
    ),
  );
  if (resume == true && context.mounted) {
    await context.push(AppRoutePaths.payment(pending.booking!.id));
  }
  return false;
}
