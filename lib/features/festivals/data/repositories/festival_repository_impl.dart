import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/festivals/domain/repositories/festival_repository.dart';

class FestivalRepositoryImpl implements FestivalRepository {
  const FestivalRepositoryImpl();

  @override
  Future<List<Festival>> getFestivals({int limit = 10}) async {
    return const <Festival>[
      Festival(
        id: 'family-film-week',
        title: 'Festival',
        subtitle: 'Tuần lễ phim gia đình tại FilmGo',
      ),
      Festival(
        id: 'movie-weekend',
        title: 'Movie Weekend',
        subtitle: 'Ưu đãi đặc biệt cho nhóm bạn',
      ),
    ].take(limit).toList(growable: false);
  }
}
