import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/booking/presentation/booking_navigation.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';
import 'package:mtbs_app/features/movies/presentation/view_models/movie_controller.dart';
import 'package:mtbs_app/features/movies/presentation/widgets/trailer_player.dart';
import 'package:mtbs_app/features/showtimes/domain/entities/showtime.dart';
import 'package:mtbs_app/features/showtimes/presentation/view_models/showtime_controller.dart';
import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';
import 'package:mtbs_app/features/waitlist/data/waitlist_data_providers.dart';
import 'package:mtbs_app/features/waitlist/presentation/view_models/waitlist_controller.dart';
import 'package:mtbs_app/features/reviews/presentation/pages/movie_reviews_tab.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({required this.movieId, super.key});

  final String movieId;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.invalidate(movieDetailProvider(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(movieDetailProvider(widget.movieId));

    return Scaffold(
      body: movie.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(movieDetailProvider(widget.movieId)),
        ),
        data: (item) => _MovieDetailContent(movie: item),
      ),
    );
  }
}

class _MovieDetailContent extends StatelessWidget {
  const _MovieDetailContent({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: NestedScrollView(
      headerSliverBuilder: (context, _) => <Widget>[
        SliverAppBar.large(
          expandedHeight: 440,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _HeroPoster(movie: movie),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarHeaderDelegate(
            TabBar(
              tabs: const <Widget>[
                Tab(text: 'Thông tin'),
                Tab(text: 'Suất chiếu'),
                Tab(text: 'Đánh giá'),
              ],
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
      body: TabBarView(
        children: <Widget>[
          _MovieInfoTab(movie: movie),
          _MovieShowtimesTab(movieId: movie.id),
          MovieReviewsTab(movieId: movie.id),
        ],
      ),
    ),
  );
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarHeaderDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarHeaderDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}

class _HeroPoster extends StatelessWidget {
  const _HeroPoster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      NetworkImageCard(
        imageUrl: movie.image?.url,
        borderRadius: BorderRadius.zero,
      ),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0x33000000),
              Color(0x66000000),
              Color(0xF2090A0D),
            ],
          ),
        ),
      ),
      if (movie.trailer?.url?.isNotEmpty ?? false)
        Center(
          child: _PosterPlayButton(
            onPressed: () => _showTrailerDialog(context, movie.trailer!.url!),
          ),
        ),
      Positioned(
        left: 18,
        right: 18,
        bottom: 72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              movie.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _subtitle(movie),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PosterPlayButton extends StatelessWidget {
  const _PosterPlayButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.52),
          border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: const SizedBox.square(
          dimension: 78,
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 54),
        ),
      ),
    ),
  );
}

class _MovieInfoTab extends ConsumerStatefulWidget {
  const _MovieInfoTab({required this.movie});

  final Movie movie;

  @override
  ConsumerState<_MovieInfoTab> createState() => _MovieInfoTabState();
}

class _MovieInfoTabState extends ConsumerState<_MovieInfoTab> {
  bool _updatingWaitlist = false;

  Future<void> _toggleWaitlist(bool isSaved) async {
    setState(() => _updatingWaitlist = true);
    try {
      final repository = ref.read(waitlistRepositoryProvider);
      if (isSaved) {
        await repository.removeMovie(widget.movie.id);
      } else {
        await repository.addMovie(widget.movie.id);
      }
      ref
        ..invalidate(waitlistStatusProvider(widget.movie.id))
        ..invalidate(waitlistProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              isSaved
                  ? 'Đã xoá khỏi danh sách chờ.'
                  : 'Đã lưu vào danh sách chờ.',
            ),
          ),
        );
    } catch (error) {
      if (mounted) showAppErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _updatingWaitlist = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final genres = movie.genres
        .map((genre) => genre.name)
        .where((name) => name.trim().isNotEmpty)
        .join(' • ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _InfoChip(icon: Icons.local_movies, label: movie.type),
            _InfoChip(icon: Icons.schedule, label: _durationLabel(movie)),
            _InfoChip(icon: Icons.badge_outlined, label: movie.ageRating),
            if (movie.ratingAverage > 0)
              _InfoChip(
                icon: Icons.star,
                label: movie.ratingAverage.toStringAsFixed(1),
                iconColor: const Color(0xFFFFD54F),
              ),
          ],
        ),
        const SizedBox(height: 18),
        _MoviePrimaryActionButton(
          movieId: movie.id,
          updatingWaitlist: _updatingWaitlist,
          onToggleWaitlist: _toggleWaitlist,
          onBook: () => DefaultTabController.of(context).animateTo(1),
        ),
        const SizedBox(height: 24),
        _Section(
          title: 'Nội dung phim',
          child: Text(
            movie.description.trim().isEmpty
                ? 'Chưa có mô tả cho phim này.'
                : movie.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.48,
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _FactGrid(movie: movie, genres: genres),
        if (movie.actors.isNotEmpty) ...<Widget>[
          const SizedBox(height: 24),
          _Section(
            title: 'Diễn viên',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: movie.actors
                  .map(
                    (actor) => Chip(
                      label: Text(actor),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ],
    );
  }
}

class _MovieShowtimesTab extends ConsumerStatefulWidget {
  const _MovieShowtimesTab({required this.movieId});

  final String movieId;

  @override
  ConsumerState<_MovieShowtimesTab> createState() => _MovieShowtimesTabState();
}

class _MovieShowtimesTabState extends ConsumerState<_MovieShowtimesTab> {
  late DateTime _selectedDate;
  String? _selectedTheaterId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    ref.invalidate(
      movieShowtimesProvider((movieId: widget.movieId, date: _selectedDate)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = (movieId: widget.movieId, date: _selectedDate);
    final showtimes = ref.watch(movieShowtimesProvider(query));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(movieShowtimesProvider(query)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
        children: <Widget>[
          _DateSelector(
            selectedDate: _selectedDate,
            onSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedTheaterId = null;
              });
              ref.invalidate(
                movieShowtimesProvider((movieId: widget.movieId, date: date)),
              );
            },
          ),
          const SizedBox(height: 16),
          showtimes.when(
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: AppHashLoader()),
            ),
            error: (error, _) => SizedBox(
              height: 260,
              child: AsyncErrorView(
                error: error,
                onRetry: () => ref.invalidate(movieShowtimesProvider(query)),
              ),
            ),
            data: (items) {
              final theaters = _theatersFromShowtimes(items);
              final filtered = _selectedTheaterId == null
                  ? items
                  : items
                        .where(
                          (item) =>
                              item.screen.theater?.id == _selectedTheaterId,
                        )
                        .toList(growable: false);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TheaterSelector(
                    theaters: theaters,
                    selectedTheaterId: _selectedTheaterId,
                    onSelected: (id) {
                      setState(() => _selectedTheaterId = id);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const _EmptyShowtimes()
                  else
                    ..._groupByTheater(filtered).entries.map(
                      (entry) => _TheaterShowtimeGroup(
                        theater: entry.value.theater,
                        showtimes: entry.value.showtimes,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoviePrimaryActionButton extends ConsumerWidget {
  const _MoviePrimaryActionButton({
    required this.movieId,
    required this.updatingWaitlist,
    required this.onToggleWaitlist,
    required this.onBook,
  });

  final String movieId;
  final bool updatingWaitlist;
  final ValueChanged<bool> onToggleWaitlist;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(waitlistStatusProvider(movieId));

    return status.when(
      loading: () =>
          const SizedBox(height: 52, child: Center(child: AppHashLoader())),
      error: (_, _) => OutlinedButton.icon(
        onPressed: updatingWaitlist
            ? null
            : () => ref.invalidate(waitlistStatusProvider(movieId)),
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Tải lại trạng thái danh sách chờ'),
      ),
      data: (item) {
        if (!item.canAddToWaitlist) {
          return GradientButton(
            label: 'Đặt vé',
            icon: const Icon(Icons.confirmation_number, color: Colors.white),
            onPressed: onBook,
          );
        }

        final label = item.isSaved
            ? 'Xoá khỏi danh sách chờ'
            : 'Lưu vào danh sách chờ';
        final icon = item.isSaved
            ? Icons.bookmark_remove_outlined
            : Icons.bookmark_add_outlined;

        if (item.isSaved) {
          return OutlinedButton.icon(
            onPressed: updatingWaitlist
                ? null
                : () => onToggleWaitlist(item.isSaved),
            icon: updatingWaitlist
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icon),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          );
        }

        return GradientButton(
          label: label,
          icon: Icon(icon, color: Colors.white),
          isLoading: updatingWaitlist,
          onPressed: updatingWaitlist
              ? null
              : () => onToggleWaitlist(item.isSaved),
        );
      },
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.selectedDate, required this.onSelected});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List<DateTime>.generate(7, (index) {
      final date = today.add(Duration(days: index));
      return DateTime(date.year, date.month, date.day);
    });

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final selected = _isSameDay(date, selectedDate);
          return ChoiceChip(
            selected: selected,
            onSelected: (_) => onSelected(date),
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_weekdayLabel(date)),
                const SizedBox(height: 2),
                Text(DateFormat('dd/MM').format(date)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TheaterSelector extends StatelessWidget {
  const _TheaterSelector({
    required this.theaters,
    required this.selectedTheaterId,
    required this.onSelected,
  });

  final List<Theater> theaters;
  final String? selectedTheaterId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (theaters.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: theaters.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              selected: selectedTheaterId == null,
              label: const Text('Tất cả rạp'),
              onSelected: (_) => onSelected(null),
            );
          }

          final theater = theaters[index - 1];
          return ChoiceChip(
            selected: selectedTheaterId == theater.id,
            label: Text(theater.name),
            onSelected: (_) => onSelected(theater.id),
          );
        },
      ),
    );
  }
}

class _TheaterShowtimeGroup extends ConsumerWidget {
  const _TheaterShowtimeGroup({required this.theater, required this.showtimes});

  final Theater? theater;
  final List<Showtime> showtimes;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF16181E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              theater?.name ?? 'Rạp chiếu',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (theater?.address.isNotEmpty ?? false) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                theater!.address,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.62),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: showtimes
                  .map((showtime) {
                    return OutlinedButton(
                      onPressed: () =>
                          startBookingFlow(context, ref, showtime.id),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(DateFormat('HH:mm').format(showtime.startTime)),
                          if (showtime.screen.name.isNotEmpty)
                            Text(
                              showtime.screen.name,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EmptyShowtimes extends StatelessWidget {
  const _EmptyShowtimes();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 220,
    child: Center(
      child: Text(
        'Không có suất chiếu cho ngày hoặc rạp đã chọn.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.72),
        ),
      ),
    ),
  );
}

class _MovieReviewsPlaceholderTab extends StatelessWidget {
  const _MovieReviewsPlaceholderTab();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
    children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF16181E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.rate_review_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Đánh giá phim',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Chức năng đánh giá sẽ được bổ sung sau.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 17, color: iconColor),
    label: Text(label),
    visualDensity: VisualDensity.compact,
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}

class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.movie, required this.genres});

  final Movie movie;
  final String genres;

  @override
  Widget build(BuildContext context) {
    final facts = <_MovieFact>[
      _MovieFact('Thể loại', genres.isEmpty ? 'Chưa cập nhật' : genres),
      _MovieFact(
        'Đạo diễn',
        movie.author.trim().isEmpty ? 'Chưa cập nhật' : movie.author,
      ),
      _MovieFact(
        'Quốc gia',
        movie.origin.trim().isEmpty ? 'Chưa cập nhật' : movie.origin,
      ),
      _MovieFact('Khởi chiếu', _formatDate(movie.releaseDate)),
      _MovieFact('Kết thúc', _formatDate(movie.endDate)),
      _MovieFact(
        'Lượt đặt',
        NumberFormat.decimalPattern().format(movie.totalBookings),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 3 : 2;
        final itemWidth =
            (constraints.maxWidth - (12 * (columns - 1))) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: facts
              .map(
                (fact) => SizedBox(
                  width: itemWidth,
                  child: _FactTile(fact: fact),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _FactTile extends StatelessWidget {
  const _FactTile({required this.fact});

  final _MovieFact fact;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFF16181E),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            fact.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.58),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            fact.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

class _MovieFact {
  const _MovieFact(this.label, this.value);

  final String label;
  final String value;
}

class _TheaterShowtimeBucket {
  const _TheaterShowtimeBucket({
    required this.theater,
    required this.showtimes,
  });

  final Theater? theater;
  final List<Showtime> showtimes;
}

List<Theater> _theatersFromShowtimes(List<Showtime> showtimes) {
  final theaters = <String, Theater>{};
  for (final showtime in showtimes) {
    final theater = showtime.screen.theater;
    if (theater != null && theater.id.isNotEmpty) {
      theaters[theater.id] = theater;
    }
  }
  final result = theaters.values.toList(growable: false);
  result.sort((a, b) => a.name.compareTo(b.name));
  return result;
}

Map<String, _TheaterShowtimeBucket> _groupByTheater(List<Showtime> showtimes) {
  final grouped = <String, _TheaterShowtimeBucket>{};
  for (final showtime in showtimes) {
    final theater = showtime.screen.theater;
    final key = theater?.id.isNotEmpty == true ? theater!.id : 'unknown';
    final existing = grouped[key];
    if (existing == null) {
      grouped[key] = _TheaterShowtimeBucket(
        theater: theater,
        showtimes: <Showtime>[showtime],
      );
    } else {
      existing.showtimes.add(showtime);
    }
  }
  return grouped;
}

String _durationLabel(Movie movie) {
  if (movie.duration <= 0) return 'Chưa cập nhật';
  return '${movie.duration} phút';
}

String _subtitle(Movie movie) {
  final parts = <String>[
    if (movie.origin.trim().isNotEmpty) movie.origin,
    _durationLabel(movie),
    movie.ageRating,
  ];
  return parts.join(' • ');
}

String _formatDate(DateTime? value) {
  if (value == null) return 'Chưa cập nhật';
  return DateFormat('dd/MM/yyyy').format(value);
}

String _weekdayLabel(DateTime date) {
  if (_isSameDay(date, DateTime.now())) return 'Hôm nay';
  return switch (date.weekday) {
    DateTime.monday => 'T2',
    DateTime.tuesday => 'T3',
    DateTime.wednesday => 'T4',
    DateTime.thursday => 'T5',
    DateTime.friday => 'T6',
    DateTime.saturday => 'T7',
    _ => 'CN',
  };
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Future<void> _showTrailerDialog(BuildContext context, String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) {
    return _showTrailerLinkDialog(context, url);
  }

  return showDialog<void>(
    context: context,
    builder: (context) => _TrailerPlayerDialog(url: url, uri: uri),
  );
}

Future<void> _showTrailerLinkDialog(BuildContext context, String url) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Trailer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.play_circle_fill,
            color: Color(0xFFFF4B6E),
            size: 48,
          ),
          const SizedBox(height: 12),
          SelectableText(url),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Đóng'),
        ),
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (!context.mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã sao chép link trailer')),
            );
          },
          icon: const Icon(Icons.copy),
          label: const Text('Copy link'),
        ),
      ],
    ),
  );
}

class _TrailerPlayerDialog extends StatefulWidget {
  const _TrailerPlayerDialog({required this.url, required this.uri});

  final String url;
  final Uri uri;

  @override
  State<_TrailerPlayerDialog> createState() => _TrailerPlayerDialogState();
}

class _TrailerPlayerDialogState extends State<_TrailerPlayerDialog> {
  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Trailer'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Đóng',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: TrailerPlayer(url: widget.url, uri: widget.uri),
    ),
  );
}
