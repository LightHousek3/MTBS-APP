// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TicketPrice _$TicketPriceFromJson(Map<String, dynamic> json) => _TicketPrice(
  id: json['id'] as String,
  typeSeat: json['typeSeat'] as String,
  typeMovie: json['typeMovie'] as String,
  price: (json['price'] as num).toInt(),
  dayType: json['dayType'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$TicketPriceToJson(_TicketPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeSeat': instance.typeSeat,
      'typeMovie': instance.typeMovie,
      'price': instance.price,
      'dayType': instance.dayType,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
