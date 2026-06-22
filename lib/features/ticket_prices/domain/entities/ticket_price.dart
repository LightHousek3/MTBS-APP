import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_price.freezed.dart';
part 'ticket_price.g.dart';

@freezed
abstract class TicketPrice with _$TicketPrice {
  const factory TicketPrice({
    required String id,
    required String typeSeat,
    required String typeMovie,
    required int price,
    required String dayType,
    required String startTime,
    required String endTime,
  }) = _TicketPrice;

  factory TicketPrice.fromJson(Map<String, dynamic> json) =>
      _$TicketPriceFromJson(json);
}
