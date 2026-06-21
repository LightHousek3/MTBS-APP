import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/showtimes/data/services/showtime_api_service.dart';

final showtimeApiServiceProvider = Provider<ShowtimeApiService>((ref) {
  return ShowtimeApiService(ref.watch(dioClientProvider));
});
