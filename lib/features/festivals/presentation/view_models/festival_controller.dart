import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/festivals/data/festival_data_providers.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';

final festivalListProvider = FutureProvider<List<Festival>>((ref) {
  return ref.watch(festivalRepositoryProvider).getFestivals(limit: 50);
});

final festivalDetailProvider = FutureProvider.family<Festival?, String>((ref, id) async {
  final festivalList = await ref.watch(festivalListProvider.future);
  try {
    return festivalList.firstWhere((item) => item.id == id);
  } catch (_) {
    return ref.watch(festivalApiServiceProvider).getFestivalById(id);
  }
});
