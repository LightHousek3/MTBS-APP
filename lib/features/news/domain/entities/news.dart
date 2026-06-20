import 'package:freezed_annotation/freezed_annotation.dart';

part 'news.freezed.dart';

@freezed
abstract class News with _$News {
  const factory News({
    required String id,
    required String title,
    required String subtitle,
    String? imageUrl,
  }) = _News;
}
