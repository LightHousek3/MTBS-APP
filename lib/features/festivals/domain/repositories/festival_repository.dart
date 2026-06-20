import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';

abstract interface class FestivalRepository {
  Future<List<Festival>> getFestivals({int limit = 10});
}
