import 'package:mtbs_app/features/home/data/services/home_api_service.dart';
import 'package:mtbs_app/features/home/domain/entities/home_banner.dart';
import 'package:mtbs_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._service);

  final HomeApiService _service;

  @override
  Future<List<HomeBanner>> getBanners() => _service.getBanners();

  @override
  Future<List<String>> getTheaterLocations() => _service.getTheaterLocations();
}
