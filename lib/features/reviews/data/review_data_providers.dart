import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/reviews/data/datasources/review_api_service.dart';
import 'package:mtbs_app/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:mtbs_app/features/reviews/domain/repositories/review_repository.dart';

final reviewApiServiceProvider = Provider<ReviewApiService>((ref) {
  return ReviewApiService(ref.watch(dioClientProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewApiServiceProvider));
});
