import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/booking/domain/entities/booking_entities.dart';

class BookingApiService {
  const BookingApiService(this._client);
  final DioClient _client;

  Future<SeatingData> getSeating(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/showtimes/$id/seating',
    );
    return ApiResponse<SeatingData>.fromJson(
      response.data!,
      (json) => SeatingData.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<List<CinemaService>> getServices(String theaterId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/services',
      queryParameters: <String, dynamic>{
        'theater': theaterId,
        'status': 'AVAILABLE',
        'limit': 50,
      },
    );
    return ApiResponse<List<CinemaService>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => CinemaService.fromJson(item! as Map<String, dynamic>))
          .toList(),
    ).data!;
  }

  Future<Booking> createBooking({
    required String showtimeId,
    required List<String> seatIds,
    required Map<String, int> services,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/bookings',
      data: <String, dynamic>{
        'showtime': showtimeId,
        'seats': seatIds,
        'services': services.entries
            .map(
              (entry) => <String, dynamic>{
                'serviceId': entry.key,
                'quantity': entry.value,
              },
            )
            .toList(),
      },
    );
    return _booking(response.data!);
  }

  Future<Booking?> getPendingBooking() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/bookings/pending',
    );
    final data = response.data?['data'];
    return data is Map<String, dynamic> ? Booking.fromJson(data) : null;
  }

  Future<List<Booking>> getBookings({
    String? status,
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/bookings',
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': 'createdAt:desc',
        if (status != null && status != 'ALL') 'status': status,
      },
    );
    return ApiResponse<List<Booking>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Booking.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<Booking> getBooking(String id) async => _booking(
    (await _client.get<Map<String, dynamic>>('/bookings/$id')).data!,
  );
  Future<Booking> cancelBooking(String id) async => _booking(
    (await _client.patch<Map<String, dynamic>>('/bookings/$id/cancel')).data!,
  );

  Future<String> createPaymentUrl(String bookingId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/payments/vnpay',
      data: <String, dynamic>{
        'bookingId': bookingId,
        'appReturnUrl': 'mtbs:///payment-result',
      },
    );
    return (response.data!['data'] as Map<String, dynamic>)['paymentUrl']!
        as String;
  }

  Booking _booking(Map<String, dynamic> json) =>
      Booking.fromJson(json['data']! as Map<String, dynamic>);
}
