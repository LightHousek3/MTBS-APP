import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:mtbs_app/features/booking/data/services/booking_api_service.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/domain/repositories/booking_repository.dart';

final bookingApiServiceProvider = Provider<BookingApiService>(
  (ref) => BookingApiService(ref.watch(dioClientProvider)),
);
final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepositoryImpl(ref.watch(bookingApiServiceProvider)),
);

final seatingProvider = FutureProvider.autoDispose.family<SeatingData, String>(
  (ref, id) => ref.watch(bookingRepositoryProvider).getSeating(id),
);
final cinemaServicesProvider = FutureProvider.autoDispose
    .family<List<CinemaService>, String>(
      (ref, theaterId) =>
          ref.watch(bookingRepositoryProvider).getServices(theaterId),
    );
final bookingDetailsProvider = FutureProvider.family<Booking, String>(
  (ref, id) => ref.watch(bookingRepositoryProvider).getBooking(id),
);
final bookingHistoryProvider = FutureProvider.autoDispose
    .family<List<Booking>, String?>((ref, status) {
      return ref.watch(bookingRepositoryProvider).getBookings(status: status);
    });
final paymentUrlProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, id) => ref.watch(bookingRepositoryProvider).createPaymentUrl(id),
);

final bookingDraftControllerProvider =
    NotifierProvider<BookingDraftController, BookingDraft?>(
      BookingDraftController.new,
    );

class BookingDraftController extends Notifier<BookingDraft?> {
  @override
  BookingDraft? build() => null;
  void setDraft(SeatingData seating, List<CinemaSeat> seats) => state =
      BookingDraft(seating: seating, selectedSeats: List.unmodifiable(seats));
  void clear() => state = null;
}

class PendingBookingState {
  const PendingBookingState({this.booking, this.secondsLeft = 0});
  final Booking? booking;
  final int secondsLeft;
  bool get isActive => booking?.isPending == true && secondsLeft > 0;
  String get formattedTime =>
      '${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}';
}

final pendingBookingControllerProvider =
    AsyncNotifierProvider<PendingBookingController, PendingBookingState>(
      PendingBookingController.new,
    );

class PendingBookingController extends AsyncNotifier<PendingBookingState> {
  Timer? _timer;
  BookingRepository get _repository => ref.read(bookingRepositoryProvider);

  @override
  Future<PendingBookingState> build() async {
    ref.onDispose(() => _timer?.cancel());
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const PendingBookingState();
    final booking = await _repository.getPendingBooking();
    final next = _stateFor(booking);
    _startTimer(next);
    return next;
  }

  Future<void> refresh() async {
    final booking = await _repository.getPendingBooking();
    final next = _stateFor(booking);
    state = AsyncData(next);
    _startTimer(next);
  }

  void setPending(Booking booking) {
    final next = _stateFor(booking);
    state = AsyncData(next);
    _startTimer(next);
  }

  void clear() {
    _timer?.cancel();
    state = const AsyncData(PendingBookingState());
  }

  Future<void> cancel(String bookingId) async {
    await _repository.cancelBooking(bookingId);
    clear();
  }

  PendingBookingState _stateFor(Booking? booking) {
    if (booking == null || !booking.isPending) {
      return const PendingBookingState();
    }
    return PendingBookingState(
      booking: booking,
      secondsLeft: booking.expiresAt
          .difference(DateTime.now())
          .inSeconds
          .clamp(0, 600),
    );
  }

  void _startTimer(PendingBookingState initial) {
    _timer?.cancel();
    if (!initial.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.value;
      final booking = current?.booking;
      if (booking == null) return clear();
      final seconds = booking.expiresAt.difference(DateTime.now()).inSeconds;
      if (seconds <= 0) return clear();
      state = AsyncData(
        PendingBookingState(booking: booking, secondsLeft: seconds),
      );
    });
  }
}

final bookingCheckoutControllerProvider =
    AsyncNotifierProvider<BookingCheckoutController, void>(
      BookingCheckoutController.new,
    );

class BookingCheckoutController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<Booking?> create(Map<String, int> services) async {
    final draft = ref.read(bookingDraftControllerProvider);
    if (draft == null) return null;
    state = const AsyncLoading();
    try {
      final booking = await ref
          .read(bookingRepositoryProvider)
          .createBooking(
            showtimeId: draft.seating.showtime.id,
            seatIds: draft.selectedSeats.map((seat) => seat.id).toList(),
            services: services,
          );
      ref.read(pendingBookingControllerProvider.notifier).setPending(booking);
      state = const AsyncData(null);
      return booking;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
