import 'package:mtbs_app/features/booking/data/services/booking_api_service.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';
import 'package:mtbs_app/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._api);
  final BookingApiService _api;
  @override
  Future<SeatingData> getSeating(String id) => _api.getSeating(id);
  @override
  Future<List<CinemaService>> getServices(String id) => _api.getServices(id);
  @override
  Future<Booking> createBooking({
    required String showtimeId,
    required List<String> seatIds,
    required Map<String, int> services,
  }) => _api.createBooking(
    showtimeId: showtimeId,
    seatIds: seatIds,
    services: services,
  );
  @override
  Future<Booking?> getPendingBooking() => _api.getPendingBooking();
  @override
  Future<List<Booking>> getBookings({
    String? status,
    int page = 1,
    int limit = 30,
  }) => _api.getBookings(status: status, page: page, limit: limit);
  @override
  Future<Booking> getBooking(String id) => _api.getBooking(id);
  @override
  Future<Booking> cancelBooking(String id) => _api.cancelBooking(id);
  @override
  Future<String> createPaymentUrl(String id, {String method = 'vnpay'}) =>
      _api.createPaymentUrl(id, method: method);
  @override
  Future<RefundRequest> createRefundRequest({
    required String bookingId,
    required String reason,
  }) => _api.createRefundRequest(bookingId: bookingId, reason: reason);
  @override
  Future<RefundRequest> cancelRefundRequest(String id) =>
      _api.cancelRefundRequest(id);
}
