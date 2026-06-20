import 'package:mtbs_app/features/home/domain/entities/home_banner.dart';

abstract interface class HomeRepository {
  Future<List<HomeBanner>> getBanners();
  Future<List<String>> getTheaterLocations();
}
