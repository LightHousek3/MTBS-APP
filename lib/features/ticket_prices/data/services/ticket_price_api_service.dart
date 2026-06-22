import 'package:mtbs_app/core/network/api_response.dart';
import 'package:mtbs_app/core/network/dio_client.dart';
import 'package:mtbs_app/features/ticket_prices/domain/entities/ticket_price.dart';

class TicketPriceApiService {
  const TicketPriceApiService(this._client);
  final DioClient _client;

  Future<List<TicketPrice>> getList() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ticket-prices',
      queryParameters: <String, dynamic>{
        'limit': 100, // Fetch all prices
      },
    );
    return ApiResponse<List<TicketPrice>>.fromJson(
      response.data!,
      (json) => (json! as List<Object?>)
          .map((item) => TicketPrice.fromJson(item! as Map<String, dynamic>))
          .toList(growable: false),
    ).data!;
  }
}
