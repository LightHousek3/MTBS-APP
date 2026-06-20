import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';
import 'package:mtbs_app/features/movies/presentation/view_models/movie_controller.dart';
import 'package:mtbs_app/features/movies/presentation/widgets/movie_card.dart';

class MoviesPage extends ConsumerWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowShowing = ref.watch(nowShowingProvider);
    final comingSoon = ref.watch(comingSoonProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phim'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Đang chiếu'),
              Tab(text: 'Sắp chiếu'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _MovieGrid(
              value: nowShowing,
              retry: () => ref.invalidate(nowShowingProvider),
            ),
            _MovieGrid(
              value: comingSoon,
              retry: () => ref.invalidate(comingSoonProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.value, required this.retry});
  final AsyncValue<List<Movie>> value;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) => value.when(
    loading: () => const Center(child: AppHashLoader()),
    error: (error, _) => AsyncErrorView(error: error, onRetry: retry),
    data: (movies) => GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        mainAxisExtent: 300,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
      ),
      itemCount: movies.length,
      itemBuilder: (_, index) => MovieCard(movie: movies[index]),
    ),
  );
}
