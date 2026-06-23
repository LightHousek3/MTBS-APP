import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/waitlist/data/repositories/waitlist_repository_impl.dart';
import 'package:mtbs_app/features/waitlist/data/services/waitlist_api_service.dart';
import 'package:mtbs_app/features/waitlist/domain/repositories/waitlist_repository.dart';

final waitlistApiServiceProvider = Provider<WaitlistApiService>((ref) {
  return WaitlistApiService(ref.watch(dioClientProvider));
});

final waitlistRepositoryProvider = Provider<WaitlistRepository>((ref) {
  return WaitlistRepositoryImpl(ref.watch(waitlistApiServiceProvider));
});
