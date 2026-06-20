import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/festivals/data/repositories/festival_repository_impl.dart';
import 'package:mtbs_app/features/festivals/domain/repositories/festival_repository.dart';

final festivalRepositoryProvider = Provider<FestivalRepository>((ref) {
  return const FestivalRepositoryImpl();
});
