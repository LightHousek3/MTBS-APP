import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';

class NewsApiService {
  const NewsApiService(this._client);

  final DioClient _client;

  Future<List<News>> getNews({int limit = 10}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/news',
      queryParameters: <String, dynamic>{
        'limit': limit,
        'sortBy': 'createdAt:desc',
      },
    );
    return ApiResponse<List<News>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => News.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<News> getNewsById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('/news/$id');
    return ApiResponse<News>.fromJson(
      response.data!,
      (json) => News.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }
}
