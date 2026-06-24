import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/promotions/data/promotion_data_providers.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';

final promotionListProvider = FutureProvider.autoDispose<List<Promotion>>((
  ref,
) {
  return ref.watch(promotionRepositoryProvider).getPromotions(limit: 50);
});

final promotionDetailProvider = FutureProvider.autoDispose
    .family<Promotion, String>((ref, id) {
      return ref.watch(promotionRepositoryProvider).getPromotionById(id);
    });
