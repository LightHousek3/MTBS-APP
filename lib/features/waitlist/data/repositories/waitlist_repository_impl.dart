import 'package:mtbs_app/features/waitlist/data/services/waitlist_api_service.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_item.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_status.dart';
import 'package:mtbs_app/features/waitlist/domain/repositories/waitlist_repository.dart';

class WaitlistRepositoryImpl implements WaitlistRepository {
  const WaitlistRepositoryImpl(this._service);
  final WaitlistApiService _service;

  @override
  Future<List<WaitlistItem>> getComingSoon({int page = 1, int limit = 20}) {
    return _service.getComingSoon(page: page, limit: limit);
  }

  @override
  Future<WaitlistStatus> getMovieStatus(String movieId) {
    return _service.getMovieStatus(movieId);
  }

  @override
  Future<WaitlistItem> addMovie(String movieId) => _service.addMovie(movieId);

  @override
  Future<void> removeMovie(String movieId) => _service.removeMovie(movieId);
}
