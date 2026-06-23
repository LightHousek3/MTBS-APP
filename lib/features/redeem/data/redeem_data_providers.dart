import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/redeem/data/repositories/redeem_repository_impl.dart';
import 'package:mtbs_app/features/redeem/data/services/redeem_api_service.dart';
import 'package:mtbs_app/features/redeem/domain/repositories/redeem_repository.dart';

final redeemApiServiceProvider = Provider<RedeemApiService>((ref) {
  return RedeemApiService(ref.watch(dioClientProvider));
});

final redeemRepositoryProvider = Provider<RedeemRepository>((ref) {
  return RedeemRepositoryImpl(ref.watch(redeemApiServiceProvider));
});
