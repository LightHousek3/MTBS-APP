import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/movies/presentation/view_models/movie_controller.dart';

class MovieDetailPage extends ConsumerWidget {
  const MovieDetailPage({required this.movieId, super.key});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movie.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        ),
        data: (item) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar.large(
              expandedHeight: 420,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    NetworkImageCard(
                      imageUrl: item.image?.url,
                      borderRadius: BorderRadius.zero,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Colors.transparent, Colors.black],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(18),
              sliver: SliverList.list(
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      Chip(label: Text(item.ageRating)),
                      Chip(label: Text(item.type)),
                      Chip(label: Text('${item.duration} phút')),
                      if (item.ratingAverage > 0)
                        Chip(
                          avatar: const Icon(Icons.star, size: 16),
                          label: Text(item.ratingAverage.toStringAsFixed(1)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  if (item.genres.isNotEmpty)
                    Text(
                      item.genres
                          .map((genre) => genre.name)
                          .where((name) => name.isNotEmpty)
                          .join(' • '),
                    ),
                  if (item.actors.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Text('Diễn viên: ${item.actors.join(', ')}'),
                  ],
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        'Suất chiếu và đặt vé đã được tách khỏi phiên bản UI này. '
                        'Màn hình chi tiết hiện chỉ hiển thị thông tin phim.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
