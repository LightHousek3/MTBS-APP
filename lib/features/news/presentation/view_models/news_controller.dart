import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/news/data/news_data_providers.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';

final newsListProvider = FutureProvider<List<News>>((ref) {
  return ref.watch(newsRepositoryProvider).getNews(limit: 50);
});

final newsDetailProvider = FutureProvider.family<News?, String>((ref, id) async {
  final newsList = await ref.watch(newsListProvider.future);
  try {
    return newsList.firstWhere((item) => item.id == id);
  } catch (_) {
    return ref.watch(newsApiServiceProvider).getNewsById(id);
  }
});
