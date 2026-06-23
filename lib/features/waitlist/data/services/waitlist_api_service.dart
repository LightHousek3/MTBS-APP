import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_item.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_status.dart';

class WaitlistApiService {
  const WaitlistApiService(this._client);
  final DioClient _client;

  Future<List<WaitlistItem>> getComingSoon({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/waitlist/coming-soon',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );
    return ApiResponse<List<WaitlistItem>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => WaitlistItem.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<WaitlistItem> addMovie(String movieId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/waitlist/coming-soon',
      data: <String, dynamic>{'movieId': movieId},
    );
    return ApiResponse<WaitlistItem>.fromJson(
      response.data!,
      (json) => WaitlistItem.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<WaitlistStatus> getMovieStatus(String movieId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/waitlist/coming-soon/$movieId/status',
    );
    return ApiResponse<WaitlistStatus>.fromJson(
      response.data!,
      (json) => WaitlistStatus.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<void> removeMovie(String movieId) async {
    await _client.delete<Map<String, dynamic>>(
      '/waitlist/coming-soon/$movieId',
    );
  }
}
