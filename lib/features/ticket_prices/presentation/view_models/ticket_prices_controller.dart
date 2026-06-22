import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/features/ticket_prices/data/ticket_price_data_providers.dart';
import 'package:mtbs_app/features/ticket_prices/domain/entities/ticket_price.dart';

final ticketPricesProvider = FutureProvider.autoDispose<List<TicketPrice>>((ref) async {
  final repository = ref.watch(ticketPriceRepositoryProvider);
  return repository.getTicketPrices();
});
