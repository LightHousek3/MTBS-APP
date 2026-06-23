import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem_gift.dart';

class RedeemApiService {
  const RedeemApiService(this._client);
  final DioClient _client;

  Future<List<Redeem>> getList({Map<String, dynamic>? queryParameters}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/redeems',
      queryParameters: queryParameters,
    );
    return ApiResponse<List<Redeem>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => Redeem.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<Redeem> getById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('/redeems/$id');
    return ApiResponse<Redeem>.fromJson(
      response.data!,
      (json) => Redeem.fromJson(json! as Map<String, dynamic>),
    ).data!;
  }

  Future<void> redeemGift({
    required String redeemId,
    required int amount,
    required String address,
    required String phone,
  }) async {
    await _client.post<Map<String, dynamic>>(
      '/redeems/$redeemId/redeem',
      data: <String, dynamic>{
        'amount': amount,
        'address': address,
        'phone': phone,
      },
    );
  }

  Future<List<RedeemGift>> getMyRedeemGiftHistory({
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/redeem-gifts/me/history',
      queryParameters: queryParameters,
    );
    return ApiResponse<List<RedeemGift>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => RedeemGift.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }

  Future<void> cancelRedeemGift(String id) async {
    await _client.patch<Map<String, dynamic>>('/redeem-gifts/$id/cancel');
  }
}
