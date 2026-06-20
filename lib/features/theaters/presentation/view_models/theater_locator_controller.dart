import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/theaters/data/repositories/theater_repository_impl.dart';
import 'package:mtbs_app/features/theaters/data/services/theater_api_service.dart';
import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';
import 'package:mtbs_app/features/theaters/domain/repositories/theater_repository.dart';

part 'theater_locator_controller.freezed.dart';

final theaterApiServiceProvider = Provider<TheaterApiService>((ref) {
  return TheaterApiService(ref.watch(dioClientProvider));
});

final theaterRepositoryProvider = Provider<TheaterRepository>((ref) {
  return TheaterRepositoryImpl(ref.watch(theaterApiServiceProvider));
});

final theaterLocatorControllerProvider =
    AsyncNotifierProvider<TheaterLocatorController, TheaterLocatorState>(
      TheaterLocatorController.new,
    );

@freezed
abstract class TheaterDistance with _$TheaterDistance {
  const factory TheaterDistance({
    required Theater theater,
    required double distanceKm,
  }) = _TheaterDistance;
}

@freezed
abstract class TheaterLocatorState with _$TheaterLocatorState {
  const factory TheaterLocatorState({
    @Default(10) int radiusKm,
    Position? position,
    @Default(<TheaterDistance>[]) List<TheaterDistance> theaters,
  }) = _TheaterLocatorState;
}

class TheaterLocatorController extends AsyncNotifier<TheaterLocatorState> {
  static const radiusOptions = <int>[3, 5, 10, 20, 50];

  TheaterRepository get _repository => ref.read(theaterRepositoryProvider);

  @override
  Future<TheaterLocatorState> build() async {
    return const TheaterLocatorState();
  }

  Future<void> setRadius(int radiusKm) async {
    final current = _current.copyWith(radiusKm: radiusKm);
    state = AsyncData(current);
    if (current.position != null) {
      await searchNearby();
    }
  }

  Future<void> searchNearby() async {
    final previous = _current;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final position = previous.position ?? await _resolveCurrentPosition();
      final theaters = await _repository.findNearby(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusKm: previous.radiusKm,
      );
      final withDistance =
          theaters
              .map(
                (theater) => TheaterDistance(
                  theater: theater,
                  distanceKm: _distanceKm(position, theater),
                ),
              )
              .toList()
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      return previous.copyWith(position: position, theaters: withDistance);
    });
  }

  TheaterLocatorState get _current => switch (state) {
    AsyncData(:final value) => value,
    _ => const TheaterLocatorState(),
  };

  Future<Position> _resolveCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Vui lòng bật dịch vụ vị trí để tìm rạp gần bạn.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Ứng dụng cần quyền vị trí để tìm rạp gần bạn.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  double _distanceKm(Position position, Theater theater) {
    final coordinates = theater.coordinates;
    if (coordinates == null) return double.infinity;
    const earthRadiusKm = 6371.0;
    final dLat = _radians(coordinates.latitude - position.latitude);
    final dLng = _radians(coordinates.longitude - position.longitude);
    final lat1 = _radians(position.latitude);
    final lat2 = _radians(coordinates.latitude);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _radians(double degrees) => degrees * math.pi / 180;
}
