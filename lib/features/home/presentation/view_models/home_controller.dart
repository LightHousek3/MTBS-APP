import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/festivals/data/festival_data_providers.dart';
import 'package:mtbs_app/features/festivals/domain/entities/festival.dart';
import 'package:mtbs_app/features/festivals/domain/repositories/festival_repository.dart';
import 'package:mtbs_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:mtbs_app/features/home/data/services/home_api_service.dart';
import 'package:mtbs_app/features/home/domain/entities/home_banner.dart';
import 'package:mtbs_app/features/home/domain/repositories/home_repository.dart';
import 'package:mtbs_app/features/movies/data/movie_data_providers.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';
import 'package:mtbs_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:mtbs_app/features/news/data/news_data_providers.dart';
import 'package:mtbs_app/features/news/domain/entities/news.dart';
import 'package:mtbs_app/features/news/domain/repositories/news_repository.dart';
import 'package:mtbs_app/features/promotions/data/promotion_data_providers.dart';
import 'package:mtbs_app/features/promotions/domain/entities/promotion.dart';
import 'package:mtbs_app/features/promotions/domain/repositories/promotion_repository.dart';

part 'home_controller.freezed.dart';

final homeApiServiceProvider = Provider<HomeApiService>((ref) {
  return HomeApiService(ref.watch(dioClientProvider));
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeApiServiceProvider));
});

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<HomeBanner>[]) List<HomeBanner> banners,
    @Default(<Movie>[]) List<Movie> nowShowing,
    @Default(<Movie>[]) List<Movie> recommendedMovies,
    @Default(<Movie>[]) List<Movie> comingSoon,
    @Default(<Promotion>[]) List<Promotion> promotions,
    @Default(<News>[]) List<News> news,
    @Default(<Festival>[]) List<Festival> festivals,
    @Default(<String>[]) List<String> locations,
    String? selectedLocation,
  }) = _HomeState;
}

class HomeController extends AsyncNotifier<HomeState> {
  HomeRepository get _homeRepository => ref.read(homeRepositoryProvider);
  MovieRepository get _movieRepository => ref.read(movieRepositoryProvider);
  PromotionRepository get _promotionRepository =>
      ref.read(promotionRepositoryProvider);
  NewsRepository get _newsRepository => ref.read(newsRepositoryProvider);
  FestivalRepository get _festivalRepository =>
      ref.read(festivalRepositoryProvider);

  @override
  Future<HomeState> build() => _load();

  Future<void> refresh() async {
    final selectedLocation = switch (state) {
      AsyncData(:final value) => value.selectedLocation,
      _ => null,
    };
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(location: selectedLocation));
  }

  Future<void> selectLocation(String? location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(location: location));
  }

  Future<HomeState> _load({String? location}) async {
    final results = await Future.wait<Object>([
      _homeRepository.getBanners(),
      _movieRepository.getNowShowing(location: location),
      _movieRepository.getComingSoon(location: location),
      _promotionRepository.getPromotions(),
      _newsRepository.getNews(),
      _festivalRepository.getFestivals(),
      _homeRepository.getTheaterLocations(),
    ]);
    final comingSoon = results[2] as List<Movie>;
    final recommendedMovies = await _getRecommendedMovies(
      coldStartMovies: comingSoon,
    );

    return HomeState(
      banners: results[0] as List<HomeBanner>,
      nowShowing: results[1] as List<Movie>,
      recommendedMovies: recommendedMovies,
      comingSoon: comingSoon,
      promotions: results[3] as List<Promotion>,
      news: results[4] as List<News>,
      festivals: results[5] as List<Festival>,
      locations: results[6] as List<String>,
      selectedLocation: location,
    );
  }

  Future<List<Movie>> _getRecommendedMovies({
    required List<Movie> coldStartMovies,
  }) async {
    try {
      final recommendations = await _movieRepository.getRecommendations();
      return recommendations.isEmpty ? coldStartMovies : recommendations;
    } catch (_) {
      return coldStartMovies;
    }
  }
}
