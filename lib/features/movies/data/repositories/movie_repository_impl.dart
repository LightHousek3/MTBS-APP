import 'package:mtbs_app/features/movies/data/services/movie_api_service.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';
import 'package:mtbs_app/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._service);
  final MovieApiService _service;

  @override
  Future<List<Movie>> getNowShowing({String? location, int limit = 20}) =>
      _list('/movies/now-showing', <String, dynamic>{
        'limit': limit,
        if (location != null && location.isNotEmpty) 'location': location,
      });

  @override
  Future<List<Movie>> getComingSoon({String? location, int limit = 20}) =>
      _list('/movies/coming-soon', <String, dynamic>{
        'limit': limit,
        if (location != null && location.isNotEmpty) 'location': location,
      });

  @override
  Future<List<Movie>> search(String keyword, {int limit = 30}) =>
      _list('/movies', <String, dynamic>{'keyword': keyword, 'limit': limit});

  @override
  Future<List<Movie>> getRecommendations({int limit = 10}) =>
      _list('/recommendations/movies', <String, dynamic>{'limit': limit});

  @override
  Future<Movie> getById(String id) => _service.getById(id);

  Future<List<Movie>> _list(String path, Map<String, dynamic> query) =>
      _service.getList(path, query: query);
}
