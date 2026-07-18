import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';

abstract interface class BookingRepository {
  Future<SeatingData> getSeating(String showtimeId);
  Future<List<CinemaService>> getServices(String theaterId);
  Future<Booking> createBooking({
    required String showtimeId,
    required List<String> seatIds,
    required Map<String, int> services,
  });
  Future<Booking?> getPendingBooking();
  Future<List<Booking>> getBookings({
    String? status,
    int page = 1,
    int limit = 30,
  });
  Future<Booking> getBooking(String bookingId);
  Future<Booking> cancelBooking(String bookingId);
  Future<String> createPaymentUrl(String bookingId);
}
