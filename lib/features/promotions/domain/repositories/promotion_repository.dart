import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';

abstract interface class PromotionRepository {
  Future<List<Promotion>> getPromotions({int limit = 10});

  Future<Promotion> getPromotionById(String id);
}
