import 'package:mtbs_app/features/festivals/data/services/festival_api_service.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/festivals/domain/repositories/festival_repository.dart';

class FestivalRepositoryImpl implements FestivalRepository {
  const FestivalRepositoryImpl(this._apiService);

  final FestivalApiService _apiService;

  @override
  Future<List<Festival>> getFestivals({int limit = 10}) async {
    try {
      final festivalList = await _apiService.getFestivals(limit: limit);
      if (festivalList.isNotEmpty) {
        return festivalList;
      }
    } catch (_) {}
    return const <Festival>[];
  }
}
