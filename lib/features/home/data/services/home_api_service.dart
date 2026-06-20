import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/home/domain/entities/home_banner.dart';

class HomeApiService {
  const HomeApiService(this._client);

  final DioClient _client;

  Future<List<HomeBanner>> getBanners() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/banners',
      queryParameters: const <String, dynamic>{
        'type': 'IMAGE',
        'limit': 10,
        'sortBy': 'createdAt:desc',
      },
    );
    return ApiResponse<List<HomeBanner>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => HomeBanner.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<List<String>> getTheaterLocations() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/theaters/locations',
    );
    return ApiResponse<List<String>>.fromJson(
      response.data!,
      (json) =>
          (json! as List<Object?>).whereType<String>().toList(growable: false),
    ).data!;
  }
}
