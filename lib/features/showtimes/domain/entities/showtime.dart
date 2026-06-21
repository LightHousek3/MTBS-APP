import 'package:mtbs_app/features/theaters/domain/entities/theater.dart';

class Showtime {
  const Showtime({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.screen,
    this.status = '',
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final ShowtimeScreen screen;
  final String status;

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: _stringValue(json['id'] ?? json['_id']),
      startTime: DateTime.parse(_stringValue(json['startTime'])).toLocal(),
      endTime: DateTime.parse(_stringValue(json['endTime'])).toLocal(),
      screen: ShowtimeScreen.fromJson(json['screen']),
      status: _stringValue(json['status']),
    );
  }
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
