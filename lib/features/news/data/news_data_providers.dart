import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:mtbs_app/features/news/domain/repositories/news_repository.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return const NewsRepositoryImpl();
});
