import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater.freezed.dart';
part 'theater.g.dart';

@freezed
abstract class Theater with _$Theater {
  const factory Theater({
    required String id,
    required String name,
    @Default('') String location,
    required String address,
    String? phone,
    @TheaterCoordinatesConverter() TheaterCoordinates? coordinates,
  }) = _Theater;

  factory Theater.fromJson(Map<String, dynamic> json) =>
      _$TheaterFromJson(json);
}

@freezed
abstract class TheaterCoordinates with _$TheaterCoordinates {
  const factory TheaterCoordinates({
    required double latitude,
    required double longitude,
  }) = _TheaterCoordinates;
}

class TheaterCoordinatesConverter
    implements JsonConverter<TheaterCoordinates?, Object?> {
  const TheaterCoordinatesConverter();

  @override
  TheaterCoordinates? fromJson(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final values = json['coordinates'];
    if (values is! List<Object?> || values.length < 2) return null;
    final longitude = (values[0] as num?)?.toDouble();
    final latitude = (values[1] as num?)?.toDouble();
    if (latitude == null || longitude == null) return null;
    return TheaterCoordinates(latitude: latitude, longitude: longitude);
  }

  @override
  Object? toJson(TheaterCoordinates? object) {
    if (object == null) return null;
    return <String, Object>{
      'type': 'Point',
      'coordinates': <double>[object.longitude, object.latitude],
    };
  }
}
