import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:mtbs_app/features/news/data/services/news_api_service.dart';
import 'package:mtbs_app/features/news/domain/repositories/news_repository.dart';

final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService(ref.watch(dioClientProvider));
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(ref.watch(newsApiServiceProvider));
});
