import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';

class PromotionApiService {
  const PromotionApiService(this._client);

  final DioClient _client;

  Future<List<Promotion>> getPromotions({int limit = 10}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/promotions',
      queryParameters: <String, dynamic>{
        'limit': limit,
        'sortBy': 'startDate:desc',
      },
    );
    return ApiResponse<List<Promotion>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Promotion.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }
}
