import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/di/core_providers.dart';
import 'package:mtbs_app/features/ticket_prices/data/repositories/ticket_price_repository_impl.dart';
import 'package:mtbs_app/features/ticket_prices/data/services/ticket_price_api_service.dart';
import 'package:mtbs_app/features/ticket_prices/domain/repositories/ticket_price_repository.dart';

final ticketPriceApiServiceProvider = Provider<TicketPriceApiService>((ref) {
  return TicketPriceApiService(ref.watch(dioClientProvider));
});

final ticketPriceRepositoryProvider = Provider<TicketPriceRepository>((ref) {
  return TicketPriceRepositoryImpl(ref.watch(ticketPriceApiServiceProvider));
});
