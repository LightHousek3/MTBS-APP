import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem_gift.dart';

final redeemListProvider = FutureProvider.autoDispose<List<Redeem>>((ref) {
  return ref.watch(redeemRepositoryProvider).getRedeems();
});

final redeemDetailProvider = FutureProvider.autoDispose.family<Redeem, String>((
  ref,
  id,
) {
  return ref.watch(redeemRepositoryProvider).getRedeemById(id);
});

final redeemGiftHistoryProvider =
    FutureProvider.family<List<RedeemGift>, String?>((ref, status) {
      return ref
          .watch(redeemRepositoryProvider)
          .getMyRedeemGiftHistory(status: status == 'ALL' ? null : status);
    });
