import 'package:freezed_annotation/freezed_annotation.dart';

part 'festival.freezed.dart';

@freezed
abstract class Festival with _$Festival {
  const factory Festival({
    required String id,
    required String title,
    required String subtitle,
    String? content,
    String? imageUrl,
    String? category,
    String? location,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
  }) = _Festival;

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? json['content'] ?? '').toString(),
      content: json['content']?.toString(),
      imageUrl: (json['imageUrl'] ?? json['image'])?.toString(),
      category: (json['category'] ?? json['tag'])?.toString(),
      location: (json['location'] ?? json['venue'])?.toString(),
      status: json['status']?.toString(),
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'].toString())
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
