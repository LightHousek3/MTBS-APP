import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:mtbs_app/features/movies/data/services/movie_api_service.dart';
import 'package:mtbs_app/features/movies/domain/repositories/movie_repository.dart';

final movieApiServiceProvider = Provider<MovieApiService>((ref) {
  return MovieApiService(ref.watch(dioClientProvider));
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(ref.watch(movieApiServiceProvider));
});
