import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_logo.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/home/domain/entities/home_banner.dart';
import 'package:mtbs_app/features/home/presentation/view_models/home_controller.dart';
import 'package:mtbs_app/features/home/presentation/widgets/home_banner_video_player.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider);

    return Scaffold(
      drawer: const _HomeDrawer(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(child: _HomeHeader()),
            ...home.when(
              loading: () => const <Widget>[
                SliverFillRemaining(child: Center(child: AppHashLoader())),
              ],
              error: (error, _) => <Widget>[
                SliverFillRemaining(
                  child: AsyncErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(homeControllerProvider),
                  ),
                ),
              ],
              data: (state) => <Widget>[
                SliverToBoxAdapter(
                  child: _BannerSlideshow(banners: state.banners),
                ),
                SliverToBoxAdapter(
                  child: _MovieShowcase(
                    title: 'Đang Chiếu',
                    movies: state.nowShowing,
                    selectedLocation: state.selectedLocation,
                    locations: state.locations,
                    showLocationSelector: true,
                    onLocationSelected: (location) {
                      ref
                          .read(homeControllerProvider.notifier)
                          .selectLocation(location);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieShowcase(
                    title: 'Đề Xuất Cho Bạn',
                    movies: state.recommendedMovies,
                    showLocationSelector: false,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MovieShowcase(
                    title: 'Sắp Chiếu',
                    movies: state.comingSoon,
                    showLocationSelector: false,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _PromotionCarousel(promotions: state.promotions),
                ),
                SliverToBoxAdapter(child: _NewsCarousel(news: state.news)),
                SliverToBoxAdapter(
                  child: _FestivalCarousel(festivals: state.festivals),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: SizedBox(
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 34),
                onPressed: Scaffold.of(context).openDrawer,
              ),
            ),
          ),
          const AppLogo(width: 152, height: 58),
        ],
      ),
    ),
  );
}

class _BannerSlideshow extends StatefulWidget {
  const _BannerSlideshow({required this.banners});

  final List<HomeBanner> banners;

  @override
  State<_BannerSlideshow> createState() => _BannerSlideshowState();
}

class _BannerSlideshowState extends State<_BannerSlideshow> {
  static const int _loopMultiplier = 1000;
  static const Duration _imageHoldDuration = Duration(seconds: 5);
  static const Duration _slideAnimationDuration = Duration(milliseconds: 450);

  late final PageController _controller;
  Timer? _advanceTimer;
  late int _page;
  bool _isAdvancing = false;

  int get _bannerCount => widget.banners.length;

  int get _initialPage => _bannerCount * _loopMultiplier;

  int _normalizedIndex(int index) {
    final value = index % _bannerCount;
    return value < 0 ? value + _bannerCount : value;
  }

  @override
  void initState() {
    super.initState();
    _page = _initialPage;
    _controller = PageController(initialPage: _initialPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleNextAdvance();
    });
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleNextAdvance() {
    _advanceTimer?.cancel();

    final banner = widget.banners[_normalizedIndex(_page)];
    if (banner.isVideo) {
      return;
    }

    _advanceTimer = Timer(_imageHoldDuration, _advanceToNextPage);
  }

  Future<void> _advanceToNextPage() async {
    if (!mounted || !_controller.hasClients || _isAdvancing) return;
    if (_bannerCount < 2) return;

    _advanceTimer?.cancel();
    _isAdvancing = true;
    try {
      await _controller.nextPage(
        duration: _slideAnimationDuration,
        curve: Curves.easeInOutCubic,
      );
    } finally {
      _isAdvancing = false;
    }
  }

  void _handleVideoCompleted(int completedPage) {
    if (completedPage != _page) return;
    _advanceToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const _EmptyHomeBlock(message: 'Chưa có banner.');
    }

    return SizedBox(
      height: 248,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _page = index);
              _scheduleNextAdvance();
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[_normalizedIndex(index)];
              final isActive = index == _page;
              return _BannerSlide(
                key: ValueKey<String>('banner-slide-${banner.id}-$index'),
                banner: banner,
                isActive: isActive,
                pageIndex: index,
                onVideoCompleted: _handleVideoCompleted,
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _bannerCount,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: _normalizedIndex(_page) == index ? 34 : 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _normalizedIndex(_page) == index
                        ? const Color(0xFFFF4B6E)
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    super.key,
    required this.banner,
    required this.isActive,
    required this.pageIndex,
    required this.onVideoCompleted,
  });

  final HomeBanner banner;
  final bool isActive;
  final int pageIndex;
  final ValueChanged<int> onVideoCompleted;

  @override
  Widget build(BuildContext context) {
    final content = banner.isVideo
        ? _BannerVideo(
            url: banner.url,
            isActive: isActive,
            pageIndex: pageIndex,
            onVideoCompleted: onVideoCompleted,
          )
        : NetworkImageCard(
            imageUrl: banner.url,
            borderRadius: BorderRadius.zero,
          );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        content,
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.transparent, Color(0xCC090A0D)],
            ),
          ),
        ),
        if (banner.isVideo)
          const Positioned(left: 18, top: 18, child: _VideoBannerBadge()),
      ],
    );
  }
}

class _BannerVideo extends StatelessWidget {
  const _BannerVideo({
    required this.url,
    required this.isActive,
    required this.pageIndex,
    required this.onVideoCompleted,
  });

  final String url;
  final bool isActive;
  final int pageIndex;
  final ValueChanged<int> onVideoCompleted;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const ColoredBox(
        color: Color(0xFF111318),
        child: Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white54,
            size: 52,
          ),
        ),
      );
    }

    return HomeBannerVideoPlayer(
      key: ValueKey<String>('home-banner-video-$pageIndex-$url'),
      url: url,
      onCompleted: () => onVideoCompleted(pageIndex),
    );
  }
}

class _VideoBannerBadge extends StatelessWidget {
  const _VideoBannerBadge();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
    ),
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.play_circle_outline, color: Colors.white, size: 18),
          SizedBox(width: 6),
          Text(
            'Video',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

class _MovieShowcase extends StatelessWidget {
  const _MovieShowcase({
    required this.title,
    required this.movies,
    required this.showLocationSelector,
    this.locations = const <String>[],
    this.selectedLocation,
    this.onLocationSelected,
  });

  final String title;
  final List<Movie> movies;
  final bool showLocationSelector;
  final List<String> locations;
  final String? selectedLocation;
  final ValueChanged<String?>? onLocationSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              if (showLocationSelector) ...<Widget>[
                const SizedBox(width: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => _showLocationPicker(context),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B1727),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFFF4B6E),
                          size: 20,
                        ),
                        if (selectedLocation != null) ...<Widget>[
                          const SizedBox(width: 6),
                          Text(
                            selectedLocation!,
                            style: const TextStyle(
                              color: Color(0xFFFF4B6E),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        movies.isEmpty
            ? const _EmptyHomeBlock(message: 'Chưa có phim.')
            : _InfiniteMovieCarousel(movies: movies),
      ],
    ),
  );

  Future<void> _showLocationPicker(BuildContext context) async {
    final selection = await showModalBottomSheet<_LocationSelection>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Tất cả tỉnh thành'),
              selected: selectedLocation == null,
              onTap: () =>
                  Navigator.of(context).pop(const _LocationSelection(null)),
            ),
            for (final location in locations)
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(location),
                selected: selectedLocation == location,
                onTap: () =>
                    Navigator.of(context).pop(_LocationSelection(location)),
              ),
          ],
        ),
      ),
    );
    if (selection == null || selection.location == selectedLocation) return;
    onLocationSelected?.call(selection.location);
  }
}

class _LocationSelection {
  const _LocationSelection(this.location);

  final String? location;
}

class _InfiniteMovieCarousel extends StatefulWidget {
  const _InfiniteMovieCarousel({required this.movies});

  final List<Movie> movies;

  @override
  State<_InfiniteMovieCarousel> createState() => _InfiniteMovieCarouselState();
}

class _InfiniteMovieCarouselState extends State<_InfiniteMovieCarousel> {
  late final PageController _controller;
  late final int _initialPage;

  @override
  void initState() {
    super.initState();
    _initialPage = widget.movies.length * 1000;
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.58,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 430,
    child: PageView.builder(
      controller: _controller,
      clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        final movie = widget.movies[index % widget.movies.length];

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final currentPage = _controller.hasClients
                ? (_controller.page ?? _initialPage.toDouble())
                : _initialPage.toDouble();
            final distance = (currentPage - index).abs();
            final focus = (1 - distance).clamp(0.0, 1.0);
            final scale = 0.78 + (focus * 0.22);
            final opacity = 0.42 + (focus * 0.58);

            return Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: Opacity(opacity: opacity, child: child),
            );
          },
          child: _FocusedMoviePoster(movie: movie),
        );
      },
    ),
  );
}

class _FocusedMoviePoster extends StatelessWidget {
  const _FocusedMoviePoster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutePaths.movie(movie.id)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0xAA000000),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: NetworkImageCard(
                imageUrl: movie.image?.url,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            movie.title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const Icon(Icons.star, color: Color(0xFFFFD54F), size: 18),
              const SizedBox(width: 4),
              Text(
                movie.ratingAverage == 0
                    ? 'N/A'
                    : movie.ratingAverage.toStringAsFixed(1),
                style: const TextStyle(
                  color: Color(0xFFFFD54F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.schedule, size: 17, color: Colors.white54),
              const SizedBox(width: 4),
              Text('${math.max(movie.duration, 0)} phút'),
            ],
          ),
        ],
      ),
    ),
  );
}

class _PromotionCarousel extends StatelessWidget {
  const _PromotionCarousel({required this.promotions});

  final List<Promotion> promotions;

  @override
  Widget build(BuildContext context) {
    final stories = promotions
        .map(
          (promotion) => _StoryCardData(
            title: promotion.title,
            subtitle:
                '${promotion.discountType == 'PERCENT' ? '${promotion.discountValue.toStringAsFixed(0)}%' : NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(promotion.discountValue)} • ${promotion.status}',
            icon: Icons.local_offer,
            color: const Color(0xFFBE123C),
            imageUrl: promotion.imageUrl,
            onTap: () =>
                context.push(AppRoutePaths.promotionDetail(promotion.id)),
          ),
        )
        .toList(growable: false);
    return _StoryCarousel(
      title: 'Khuyến mãi',
      stories: stories,
      onHeaderTap: () => context.push(AppRoutePaths.promotions),
    );
  }
}

class _NewsCarousel extends StatelessWidget {
  const _NewsCarousel({required this.news});

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    final stories = news
        .map(
          (item) => _StoryCardData(
            title: item.title,
            subtitle: item.subtitle,
            icon: Icons.newspaper,
            color: const Color(0xFF2563EB),
            imageUrl: item.imageUrl,
            onTap: () => context.push(AppRoutePaths.newsDetail(item.id)),
          ),
        )
        .toList(growable: false);
    return _StoryCarousel(
      title: 'Tin tức',
      stories: stories,
      onHeaderTap: () => context.push(AppRoutePaths.news),
    );
  }
}

class _FestivalCarousel extends StatelessWidget {
  const _FestivalCarousel({required this.festivals});

  final List<Festival> festivals;

  @override
  Widget build(BuildContext context) {
    final stories = festivals
        .map(
          (item) => _StoryCardData(
            title: item.title,
            subtitle: item.subtitle,
            icon: Icons.celebration,
            color: const Color(0xFFF97316),
            imageUrl: item.imageUrl,
            onTap: () => context.push(AppRoutePaths.festivalDetail(item.id)),
          ),
        )
        .toList(growable: false);
    return _StoryCarousel(
      title: 'Sự kiện',
      stories: stories,
      onHeaderTap: () => context.push(AppRoutePaths.festivals),
    );
  }
}

class _StoryCarousel extends StatelessWidget {
  const _StoryCarousel({
    required this.title,
    required this.stories,
    this.onHeaderTap,
  });

  final String title;
  final List<_StoryCardData> stories;
  final VoidCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (onHeaderTap != null)
                  TextButton(
                    onPressed: onHeaderTap,
                    child: const Text('Xem tất cả'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 162,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) => _StoryCard(data: stories[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCardData {
  const _StoryCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? imageUrl;
  final VoidCallback? onTap;
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.data});

  final _StoryCardData data;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: data.onTap,
    child: Container(
      width: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF161822),
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
          // Brighter Background Image
          if (data.imageUrl != null && data.imageUrl!.isNotEmpty)
            Image.network(
              data.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1C1E26)),
            )
          else
            Container(color: const Color(0xFF1C1E26)),

          // Brighter Gradient Overlay: Subtle transition at the bottom
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x22000000),
                  Color(0x55000000),
                  Color(0xF50B0C10),
                ],
                stops: <double>[0.0, 0.45, 1.0],
              ),
            ),
          ),

          // Icon Badge (Top Left)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Icon(data.icon, size: 16, color: Colors.white),
            ),
          ),

          // Bottom Text Content
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: <Widget>[
          const ListTile(
            title: Center(child: AppLogo(width: 142, height: 52)),
            subtitle: Center(child: Text('Movie Ticket Booking')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang Chủ'),
            onTap: () => context.go(AppRoutePaths.home),
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: const Text('Rạp'),
            onTap: () => context.go(AppRoutePaths.theaters),
          ),
          ListTile(
            leading: const Icon(Icons.local_activity),
            title: const Text('Giá Vé'),
            onTap: () => context.go(AppRoutePaths.ticketPrices),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Khuyến Mãi'),
            onTap: () => context.go(AppRoutePaths.promotions),
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Tin tức'),
            onTap: () => context.go(AppRoutePaths.news),
          ),
          ListTile(
            leading: const Icon(Icons.celebration),
            title: const Text('Sự kiện'),
            onTap: () => context.go(AppRoutePaths.festivals),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Tài Khoản'),
            onTap: () => context.go(AppRoutePaths.account),
          ),
        ],
      ),
    ),
  );
}

class _EmptyHomeBlock extends StatelessWidget {
  const _EmptyHomeBlock({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: 180, child: Center(child: Text(message)));
}
