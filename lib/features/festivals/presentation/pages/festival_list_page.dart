import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/festivals/presentation/view_models/festival_controller.dart';

class FestivalListPage extends ConsumerWidget {
  const FestivalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalsState = ref.watch(festivalListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF090A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090A0F),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutePaths.home),
        ),
      ),
      body: festivalsState.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(festivalListProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(festivalListProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            children: <Widget>[
              // Header Section
              Text(
                'Sự kiện',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Các sự kiện điện ảnh nổi bật',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 72),
                  child: Center(
                    child: Text(
                      'Chưa có sự kiện nào.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                )
              else
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _FestivalCard(
                      festival: items[i],
                      index: i,
                      onTap: () => context.push(
                        AppRoutePaths.festivalDetail(items[i].id),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FestivalCard extends StatelessWidget {
  const _FestivalCard({
    required this.festival,
    required this.index,
    required this.onTap,
  });

  final Festival festival;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();

    // Date range string based ONLY on real backend data
    final String? dateStr;
    if (festival.startTime != null && festival.endTime != null) {
      dateStr =
          '${dateFormat.format(festival.startTime!)} - ${dateFormat.format(festival.endTime!)}';
    } else if (festival.startTime != null) {
      dateStr = dateFormat.format(festival.startTime!);
    } else if (festival.createdAt != null) {
      dateStr = dateFormat.format(festival.createdAt!);
    } else {
      dateStr = null;
    }

    // Location string: Only render if location is present in actual backend data
    final locationStr =
        (festival.location != null && festival.location!.trim().isNotEmpty)
            ? festival.location!.trim()
            : null;

    // Status pill based on real startTime & endTime
    final String? statusText;
    final Color statusColor;
    if (festival.startTime != null && festival.endTime != null) {
      if (now.isBefore(festival.startTime!)) {
        statusText = 'Sắp diễn ra';
        statusColor = const Color(0xFF2563EB);
      } else if (now.isAfter(festival.endTime!)) {
        statusText = 'Đã kết thúc';
        statusColor = Colors.white38;
      } else {
        statusText = 'Đang diễn ra';
        statusColor = const Color(0xFF10B981);
      }
    } else if (festival.startTime != null) {
      if (now.isBefore(festival.startTime!)) {
        statusText = 'Sắp diễn ra';
        statusColor = const Color(0xFF2563EB);
      } else {
        statusText = 'Đang diễn ra';
        statusColor = const Color(0xFF10B981);
      }
    } else if (festival.status != null && festival.status!.isNotEmpty) {
      statusText = festival.status;
      statusColor = const Color(0xFF2563EB);
    } else {
      statusText = null;
      statusColor = const Color(0xFF2563EB);
    }

    const darkRed = Color(0xFFBE123C); // Elegant Deep Dark Red

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF121319),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Image Section with Status Pill
            SizedBox(
              height: 190,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (festival.imageUrl != null && festival.imageUrl!.isNotEmpty)
                    NetworkImageCard(
                      imageUrl: festival.imageUrl,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    )
                  else
                    Container(color: const Color(0xFF1F212A)),

                  // Image Bottom Dark Gradient
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Color(0x33000000),
                          Color(0xEE121319),
                        ],
                        stops: <double>[0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // Top-Left Status Pill (only if statusText is determined)
                  if (statusText != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Text(
                    festival.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description / Subtitle
                  Text(
                    festival.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Footer: Left Info + Right "Chi tiết ->"
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Left Date & Location (only showing what actually exists in data)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (dateStr != null)
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      dateStr,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            if (locationStr != null) ...<Widget>[
                              if (dateStr != null) const SizedBox(height: 6),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      locationStr,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right "Chi tiết ->" button in Dark Red
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text(
                            'Chi tiết',
                            style: TextStyle(
                              color: darkRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: darkRed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
