import 'package:mtbs_app/features/movies/domain/entities/movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> getNowShowing({String? location, int limit = 20});
  Future<List<Movie>> getComingSoon({String? location, int limit = 20});
  Future<List<Movie>> search(String keyword, {int limit = 30});
  Future<Movie> getById(String id);
  Future<List<Movie>> getRecommendations({int limit = 10});
}
