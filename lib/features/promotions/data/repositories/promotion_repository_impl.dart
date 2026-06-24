import 'package:mtbs_app/features/promotions/data/services/promotion_api_service.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';
import 'package:mtbs_app/features/promotions/domain/repositories/promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  const PromotionRepositoryImpl(this._service);

  final PromotionApiService _service;

  @override
  Future<List<Promotion>> getPromotions({int limit = 10}) {
    return _service.getPromotions(limit: limit);
  }

  @override
  Future<Promotion> getPromotionById(String id) {
    return _service.getPromotionById(id);
  }
}
