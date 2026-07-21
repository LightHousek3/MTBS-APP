import 'package:mtbs_app/features/news/data/services/news_api_service.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';
import 'package:mtbs_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._apiService);

  final NewsApiService _apiService;

  @override
  Future<List<News>> getNews({int limit = 10}) async {
    try {
      final newsList = await _apiService.getNews(limit: limit);
      if (newsList.isNotEmpty) {
        return newsList;
      }
    } catch (_) {}
    return const <News>[];
  }
}
