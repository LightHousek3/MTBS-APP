import 'package:intl/intl.dart';
import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/showtimes/domain/entities/showtime.dart';

class ShowtimeApiService {
  const ShowtimeApiService(this._client);

  final DioClient _client;

  Future<List<Showtime>> getByMovieDate({
    required String movieId,
    required DateTime date,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/showtimes',
      queryParameters: <String, dynamic>{
        'movie': movieId,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'populate': 'screen.theater',
        'sortBy': 'startTime:asc',
        'limit': 100,
      },
    );

    final showtimes = ApiResponse<List<Showtime>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Showtime.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;

    final now = DateTime.now();
    return showtimes
        .where((showtime) => showtime.startTime.isAfter(now))
        .toList(growable: false);
  }
}
