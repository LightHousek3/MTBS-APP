import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({required String id, required String name}) = _Genre;
  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
abstract class MediaAsset with _$MediaAsset {
  const factory MediaAsset({String? url, String? publicId}) = _MediaAsset;
  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);
}

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required String id,
    required String title,
    @Default(<Genre>[]) @GenreListConverter() List<Genre> genres,
    @Default('') String description,
    @Default('') String author,
    MediaAsset? image,
    MediaAsset? trailer,
    @Default('2D') String type,
    @Default(0) int duration,
    @Default('') String origin,
    DateTime? releaseDate,
    DateTime? endDate,
    @Default('P') String ageRating,
    @Default(<String>[]) List<String> actors,
    @Default(0) int totalBookings,
    @Default(0) double ratingAverage,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

class GenreListConverter implements JsonConverter<List<Genre>, Object?> {
  const GenreListConverter();

  @override
  List<Genre> fromJson(Object? json) {
    if (json is! List<Object?>) return const <Genre>[];
    return json
        .map((item) {
          if (item is Map<String, dynamic>) return Genre.fromJson(item);
          return Genre(id: item.toString(), name: '');
        })
        .toList(growable: false);
  }

  @override
  Object toJson(List<Genre> object) => object.map((genre) => genre.id).toList();
}
