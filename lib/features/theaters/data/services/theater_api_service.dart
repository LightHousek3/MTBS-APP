import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';

class TheaterApiService {
  const TheaterApiService(this._client);

  final DioClient _client;

  Future<List<Theater>> findNearby({
    required double latitude,
    required double longitude,
    required int radiusKm,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/theaters',
      queryParameters: <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
        'maxDistance': radiusKm * 1000,
        'limit': 50,
      },
    );
    return ApiResponse<List<Theater>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Theater.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }
}
