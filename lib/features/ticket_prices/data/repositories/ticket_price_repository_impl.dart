import 'package:mtbs_app/features/ticket_prices/data/services/ticket_price_api_service.dart';
import 'package:mtbs_app/features/ticket_prices/domain/entities/ticket_price.dart';
import 'package:mtbs_app/features/ticket_prices/domain/repositories/ticket_price_repository.dart';

class TicketPriceRepositoryImpl implements TicketPriceRepository {
  const TicketPriceRepositoryImpl(this._apiService);
  final TicketPriceApiService _apiService;

  @override
  Future<List<TicketPrice>> getTicketPrices() => _apiService.getList();
}
