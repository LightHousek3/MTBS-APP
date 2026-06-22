import 'package:mtbs_app/features/ticket_prices/domain/entities/ticket_price.dart';

abstract interface class TicketPriceRepository {
  Future<List<TicketPrice>> getTicketPrices();
}
