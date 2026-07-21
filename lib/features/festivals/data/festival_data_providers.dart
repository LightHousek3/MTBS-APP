import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/festivals/data/repositories/festival_repository_impl.dart';
import 'package:mtbs_app/features/festivals/data/services/festival_api_service.dart';
import 'package:mtbs_app/features/festivals/domain/repositories/festival_repository.dart';

final festivalApiServiceProvider = Provider<FestivalApiService>((ref) {
  return FestivalApiService(ref.watch(dioClientProvider));
});

final festivalRepositoryProvider = Provider<FestivalRepository>((ref) {
  return FestivalRepositoryImpl(ref.watch(festivalApiServiceProvider));
});
