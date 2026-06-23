import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/booking/presentation/view_models/booking_controller.dart';

class PendingBookingFab extends ConsumerWidget {
  const PendingBookingFab({required this.onOpenPayment, super.key});

  final ValueChanged<String> onOpenPayment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingBookingControllerProvider).value;
    if (pending == null || !pending.isActive) return const SizedBox.shrink();
    return FloatingActionButton.extended(
      heroTag: 'pending-booking',
      backgroundColor: const Color(0xFFE30713),
      foregroundColor: Colors.white,
      onPressed: () => onOpenPayment(pending.booking!.id),
      icon: const Icon(Icons.timer_outlined),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Thanh toán ngay',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          Text(
            pending.formattedTime,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
