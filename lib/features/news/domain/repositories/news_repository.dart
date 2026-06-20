import 'package:mtbs_app/features/news/domain/entities/news.dart';

abstract interface class NewsRepository {
  Future<List<News>> getNews({int limit = 10});
}
