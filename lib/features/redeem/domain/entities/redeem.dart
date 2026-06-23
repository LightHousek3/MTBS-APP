import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtbs_app/features/movies/domain/entities/movie.dart';

part 'redeem.freezed.dart';
part 'redeem.g.dart';

@freezed
abstract class Redeem with _$Redeem {
  const factory Redeem({
    required String id,
    required String name,
    @Default('') String description,
    @Default(0) int pointsRequired,
    MediaAsset? image,
    @Default(0) int quantity,
    @Default('AVAILABLE') String status,
    DateTime? createdAt,
  }) = _Redeem;

  factory Redeem.fromJson(Map<String, dynamic> json) => _$RedeemFromJson(json);
}
