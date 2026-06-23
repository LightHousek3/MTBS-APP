import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/waitlist/data/waitlist_data_providers.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_item.dart';
import 'package:mtbs_app/features/waitlist/domain/entities/waitlist_status.dart';

final waitlistProvider = FutureProvider.autoDispose<List<WaitlistItem>>((ref) {
  return ref.watch(waitlistRepositoryProvider).getComingSoon();
});

final waitlistStatusProvider = FutureProvider.autoDispose
    .family<WaitlistStatus, String>((ref, movieId) {
      return ref.watch(waitlistRepositoryProvider).getMovieStatus(movieId);
    });
