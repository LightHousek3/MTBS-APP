import 'package:mtbs_app/features/theaters/data/services/theater_api_service.dart';
import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';
import 'package:mtbs_app/features/theaters/domain/repositories/theater_repository.dart';

class TheaterRepositoryImpl implements TheaterRepository {
  const TheaterRepositoryImpl(this._service);

  final TheaterApiService _service;

  @override
  Future<List<Theater>> findNearby({
    required double latitude,
    required double longitude,
    required int radiusKm,
  }) {
    return _service.findNearby(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }
}
