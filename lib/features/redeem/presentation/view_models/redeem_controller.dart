import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/redeem/data/redeem_data_providers.dart';
import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';

final redeemListProvider = FutureProvider<List<Redeem>>((ref) {
  return ref.watch(redeemRepositoryProvider).getRedeems();
});

final redeemDetailProvider = FutureProvider.family<Redeem, String>((ref, id) {
  return ref.watch(redeemRepositoryProvider).getRedeemById(id);
});
