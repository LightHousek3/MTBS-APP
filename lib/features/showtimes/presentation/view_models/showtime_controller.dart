import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/showtimes/data/showtime_data_providers.dart';
import 'package:mtbs_app/features/showtimes/domain/entities/showtime.dart';

typedef ShowtimeQuery = ({String movieId, DateTime date});

final movieShowtimesProvider =
    FutureProvider.family<List<Showtime>, ShowtimeQuery>((ref, query) {
      return ref
          .watch(showtimeApiServiceProvider)
          .getByMovieDate(movieId: query.movieId, date: query.date);
    });
