import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';

class MovieApiService {
  const MovieApiService(this._client);
  final DioClient _client;

  Future<List<Movie>> getList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      path,
      queryParameters: <String, dynamic>{'populate': 'genres', ...?query},
    );
    return ApiResponse<List<Movie>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Movie.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<Movie> getById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('/movies/$id');
    return ApiResponse<Movie>.fromJson(
      response.data!,
      (json) => Movie.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }
}
