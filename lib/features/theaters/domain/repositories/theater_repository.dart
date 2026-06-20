import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';

abstract interface class TheaterRepository {
  Future<List<Theater>> findNearby({
    required double latitude,
    required double longitude,
    required int radiusKm,
  });
}
