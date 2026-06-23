import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';

class Showtime {
  const Showtime({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.screen,
    this.status = '',
    this.movie,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final ShowtimeScreen screen;
  final String status;
  final ShowtimeMovie? movie;

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: _stringValue(json['id'] ?? json['_id']),
      startTime: DateTime.parse(_stringValue(json['startTime'])).toLocal(),
      endTime: DateTime.parse(_stringValue(json['endTime'])).toLocal(),
      screen: ShowtimeScreen.fromJson(json['screen']),
      status: _stringValue(json['status']),
      movie: json['movie'] is Map<String, dynamic>
          ? ShowtimeMovie.fromJson(json['movie']! as Map<String, dynamic>)
          : null,
    );
  }
}

class ShowtimeMovie {
  const ShowtimeMovie({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.imageUrl,
    this.ageRating = 'P',
  });
  final String id;
  final String title;
  final String type;
  final int duration;
  final String? imageUrl;
  final String ageRating;
  factory ShowtimeMovie.fromJson(Map<String, dynamic> json) => ShowtimeMovie(
    id: _stringValue(json['id'] ?? json['_id']),
    title: _stringValue(json['title']),
    type: _stringValue(json['type'], fallback: '2D'),
    duration: (json['duration'] as num?)?.toInt() ?? 0,
    imageUrl: json['image'] is Map<String, dynamic>
        ? (json['image'] as Map<String, dynamic>)['url']?.toString()
        : null,
    ageRating: _stringValue(json['ageRating'], fallback: 'P'),
  );
}

class ShowtimeScreen {
  const ShowtimeScreen({
    required this.id,
    required this.name,
    this.seatCapacity = 0,
    this.theater,
  });

  final String id;
  final String name;
  final int seatCapacity;
  final Theater? theater;

  factory ShowtimeScreen.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      return const ShowtimeScreen(id: '', name: 'Phòng chiếu');
    }

    final theaterJson = json['theater'];
    return ShowtimeScreen(
      id: _stringValue(json['id'] ?? json['_id']),
      name: _stringValue(json['name'], fallback: 'Phòng chiếu'),
      seatCapacity: (json['seatCapacity'] as num?)?.toInt() ?? 0,
      theater: theaterJson is Map<String, dynamic>
          ? Theater.fromJson(_normalizeTheaterJson(theaterJson))
          : null,
    );
  }
}

Map<String, dynamic> _normalizeTheaterJson(Map<String, dynamic> json) {
  return <String, dynamic>{
    ...json,
    'id': _stringValue(json['id'] ?? json['_id']),
    'name': _stringValue(json['name'], fallback: 'Rạp chiếu'),
    'address': _stringValue(json['address']),
  };
}

String _stringValue(Object? value, {String fallback = ''}) {
  final normalized = value?.toString();
  if (normalized == null || normalized.isEmpty) return fallback;
  return normalized;
}
