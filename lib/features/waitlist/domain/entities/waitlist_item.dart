import 'package:mtbs_app/features/movies/domain/entities/movie.dart';

class WaitlistItem {
  const WaitlistItem({
    required this.id,
    required this.movie,
    this.createdAt,
    this.notifiedAt,
  });

  final String id;
  final Movie movie;
  final DateTime? createdAt;
  final DateTime? notifiedAt;

  factory WaitlistItem.fromJson(Map<String, dynamic> json) {
    return WaitlistItem(
      id: json['id']?.toString() ?? '',
      movie: Movie.fromJson(json['movie']! as Map<String, dynamic>),
      createdAt: _parseDate(json['createdAt']),
      notifiedAt: _parseDate(json['notifiedAt']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
