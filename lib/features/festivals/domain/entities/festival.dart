import 'package:freezed_annotation/freezed_annotation.dart';

part 'festival.freezed.dart';

@freezed
abstract class Festival with _$Festival {
  const factory Festival({
    required String id,
    required String title,
    required String subtitle,
    String? imageUrl,
  }) = _Festival;
}
