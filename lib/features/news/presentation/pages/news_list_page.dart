import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';
import 'package:mtbs_app/features/news/presentation/view_models/news_controller.dart';

class NewsListPage extends ConsumerWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsListProvider);
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
      body: newsState.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(newsListProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(newsListProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            children: <Widget>[
              // Header Section matching image design
              Text(
                'Tin tức',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cập nhật thông tin điện ảnh mới nhất',
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
                      'Chưa có tin tức nào.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                )
              else
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _NewsCard(
                      news: items[i],
                      index: i,
                      onTap: () => context.push(
                        AppRoutePaths.newsDetail(items[i].id),
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

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.news,
    required this.index,
    required this.onTap,
  });

  final News news;
  final int index;
  final VoidCallback onTap;

  static const _defaultCategories = ['SỰ KIỆN', 'ĐIỆN ẢNH', 'TIN TỨC'];

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final dateStr = news.createdAt != null
        ? dateFormat.format(news.createdAt!)
        : dateFormat.format(DateTime.now().subtract(Duration(days: index * 2)));

    final tagText = (news.category != null && news.category!.isNotEmpty)
        ? news.category!.toUpperCase()
        : _defaultCategories[index % _defaultCategories.length];

    const darkRed = Color(0xFFBE123C); // Deep Crimson Dark Red

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 240,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF141419),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Image Background
            if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
              NetworkImageCard(
                imageUrl: news.imageUrl,
                borderRadius: BorderRadius.circular(16),
              )
            else
              Container(color: const Color(0xFF1F212A)),

            // Gradient Overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Color(0x33000000),
                    Color(0xF50A0B0E),
                  ],
                  stops: <double>[0.0, 0.45, 1.0],
                ),
              ),
            ),

            // Top Left Category Badge with Dark Red Color
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: darkRed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Bottom Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.access_time_outlined,
                        size: 15,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
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
