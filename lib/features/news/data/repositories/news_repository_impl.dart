import 'package:mtbs_app/features/news/domain/entities/news.dart';
import 'package:mtbs_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl();

  @override
  Future<List<News>> getNews({int limit = 10}) async {
    return const <News>[
      News(
        id: 'daily-movie-news',
        title: 'Tin mới',
        subtitle: 'Lịch chiếu và phim hot được cập nhật mỗi ngày',
      ),
      News(
        id: 'weekend-showtimes',
        title: 'Suất chiếu đẹp',
        subtitle: 'Gợi ý khung giờ xem phim cuối tuần',
      ),
    ].take(limit).toList(growable: false);
  }
}
