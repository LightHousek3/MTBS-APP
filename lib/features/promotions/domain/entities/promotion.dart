import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion.freezed.dart';
part 'promotion.g.dart';

@freezed
abstract class Promotion with _$Promotion {
  const factory Promotion({
    required String id,
    required String title,
    String? description,
    String? imageUrl,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) = _Promotion;

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);
}
