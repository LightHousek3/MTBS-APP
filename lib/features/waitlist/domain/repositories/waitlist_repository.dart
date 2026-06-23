import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_item.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_status.dart';

abstract interface class WaitlistRepository {
  Future<List<WaitlistItem>> getComingSoon({int page = 1, int limit = 20});
  Future<WaitlistStatus> getMovieStatus(String movieId);
  Future<WaitlistItem> addMovie(String movieId);
  Future<void> removeMovie(String movieId);
}
