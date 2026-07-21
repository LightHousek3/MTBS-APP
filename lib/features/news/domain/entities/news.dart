import 'package:freezed_annotation/freezed_annotation.dart';

part 'news.freezed.dart';

@freezed
abstract class News with _$News {
  const factory News({
    required String id,
    required String title,
    required String subtitle,
    String? content,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? json['content'] ?? '').toString(),
      content: json['content']?.toString(),
      imageUrl: (json['imageUrl'] ?? json['image'])?.toString(),
      category: (json['category'] ?? json['tag'])?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
