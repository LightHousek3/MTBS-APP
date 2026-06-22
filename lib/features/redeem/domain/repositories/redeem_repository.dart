import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';

abstract interface class RedeemRepository {
  Future<List<Redeem>> getRedeems({String? search, int limit = 20, int page = 1});
  Future<Redeem> getRedeemById(String id);
  Future<void> redeemGift({
    required String redeemId,
    int amount = 1,
    required String address,
    required String phone,
  });
}
