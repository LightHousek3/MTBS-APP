import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/festivals/presentation/view_models/festival_controller.dart';

class FestivalDetailPage extends ConsumerWidget {
  const FestivalDetailPage({super.key, required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalAsync = ref.watch(festivalDetailProvider(festivalId));
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    const darkRed = Color(0xFFBE123C); // Elegant Deep Dark Red

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sự kiện'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutePaths.festivals),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: festivalAsync.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(festivalDetailProvider(festivalId)),
        ),
        data: (festival) {
          if (festival == null) {
            return const Center(child: Text('Không tìm thấy sự kiện'));
          }

          final String? timeText;
          if (festival.startTime != null && festival.endTime != null) {
            timeText =
                '${dateFormat.format(festival.startTime!)} - ${dateFormat.format(festival.endTime!)}';
          } else if (festival.startTime != null) {
            timeText = dateFormat.format(festival.startTime!);
          } else if (festival.createdAt != null) {
            timeText = dateFormat.format(festival.createdAt!);
          } else {
            timeText = null;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (festival.imageUrl != null && festival.imageUrl!.isNotEmpty) ...<Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: NetworkImageCard(imageUrl: festival.imageUrl),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  festival.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (timeText != null) ...<Widget>[
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.event,
                        size: 18,
                        color: darkRed,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeText,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15151C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    festival.content ?? festival.subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
