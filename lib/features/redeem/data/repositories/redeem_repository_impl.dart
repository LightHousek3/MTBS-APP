import 'package:mtbs_app/features/redeem/data/services/redeem_api_service.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem_gift.dart';
import 'package:mtbs_app/features/redeem/domain/repositories/redeem_repository.dart';

class RedeemRepositoryImpl implements RedeemRepository {
  const RedeemRepositoryImpl(this._service);
  final RedeemApiService _service;

  @override
  Future<List<Redeem>> getRedeems({
    String? search,
    int limit = 20,
    int page = 1,
  }) {
    return _service.getList(
      queryParameters: <String, dynamic>{
        'limit': limit,
        'page': page,
        'sortBy': 'createdAt:desc',
        'search': ?search,
      },
    );
  }

  @override
  Future<Redeem> getRedeemById(String id) => _service.getById(id);

  @override
  Future<void> redeemGift({
    required String redeemId,
    int amount = 1,
    required String address,
    required String phone,
  }) {
    return _service.redeemGift(
      redeemId: redeemId,
      amount: amount,
      address: address,
      phone: phone,
    );
  }

  @override
  Future<List<RedeemGift>> getMyRedeemGiftHistory({
    String? status,
    int limit = 20,
    int page = 1,
  }) {
    return _service.getMyRedeemGiftHistory(
      queryParameters: <String, dynamic>{
        'limit': limit,
        'page': page,
        'sortBy': 'createdAt:desc',
        'populate': 'redeem',
        'status': ?status,
      },
    );
  }

  @override
  Future<void> cancelRedeemGift(String id) => _service.cancelRedeemGift(id);
}
