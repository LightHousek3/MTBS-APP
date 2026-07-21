import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';

class FestivalApiService {
  const FestivalApiService(this._client);

  final DioClient _client;

  Future<List<Festival>> getFestivals({int limit = 10}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/festivals',
      queryParameters: <String, dynamic>{
        'limit': limit,
        'sortBy': 'createdAt:desc',
      },
    );
    return ApiResponse<List<Festival>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Festival.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<Festival> getFestivalById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('/festivals/$id');
    return ApiResponse<Festival>.fromJson(
      response.data!,
      (json) => Festival.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }
}
