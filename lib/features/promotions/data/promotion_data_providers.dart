import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/promotions/data/repositories/promotion_repository_impl.dart';
import 'package:mtbs_app/features/promotions/data/services/promotion_api_service.dart';
import 'package:mtbs_app/features/promotions/domain/repositories/promotion_repository.dart';

final promotionApiServiceProvider = Provider<PromotionApiService>((ref) {
  return PromotionApiService(ref.watch(dioClientProvider));
});

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  return PromotionRepositoryImpl(ref.watch(promotionApiServiceProvider));
});
