import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/movies/data/movie_data_providers.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';

final nowShowingProvider = FutureProvider<List<Movie>>((ref) {
  return ref.watch(movieRepositoryProvider).getNowShowing();
});

final comingSoonProvider = FutureProvider<List<Movie>>((ref) {
  return ref.watch(movieRepositoryProvider).getComingSoon();
});

final recommendationProvider = FutureProvider<List<Movie>>((ref) {
  return ref.watch(movieRepositoryProvider).getRecommendations();
});

final movieDetailProvider = FutureProvider.autoDispose.family<Movie, String>((
  ref,
  id,
) {
  return ref.watch(movieRepositoryProvider).getById(id);
});

final movieSearchProvider = FutureProvider.family<List<Movie>, String>((
  ref,
  query,
) {
  if (query.trim().isEmpty) return Future<List<Movie>>.value(const <Movie>[]);
  return ref.watch(movieRepositoryProvider).search(query.trim());
});
