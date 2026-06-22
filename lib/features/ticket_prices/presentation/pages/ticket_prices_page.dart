import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/features/ticket_prices/domain/entities/ticket_price.dart';
import 'package:mtbs_app/features/ticket_prices/presentation/view_models/ticket_prices_controller.dart';

class TicketPricesPage extends ConsumerStatefulWidget {
  const TicketPricesPage({super.key});

  @override
  ConsumerState<TicketPricesPage> createState() => _TicketPricesPageState();
}

class _TicketPricesPageState extends ConsumerState<TicketPricesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pricesAsync = ref.watch(ticketPricesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bảng giá vé',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: pricesAsync.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(ticketPricesProvider),
        ),
        data: (prices) {
          final weekdayPrices =
              prices.where((p) => p.dayType == 'WEEKDAY').toList();
          final weekendPrices =
              prices.where((p) => p.dayType == 'WEEKEND').toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent, width: 1.5),
                      color: Colors.redAccent.withValues(alpha: 0.1),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.redAccent,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'T2 - T6'),
                      Tab(text: 'T7 - CN / Ngày Lễ'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PricesTabContent(prices: weekdayPrices),
                    _PricesTabContent(prices: weekendPrices),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PricesTabContent extends StatelessWidget {
  const _PricesTabContent({required this.prices});
  final List<TicketPrice> prices;

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu bảng giá.'));
    }

    final prices2D = prices.where((p) => p.typeMovie == '2D').toList();
    final prices3D = prices.where((p) => p.typeMovie == '3D').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (prices2D.isNotEmpty)
          _PriceSection(
            title: 'Phim 2D',
            headerColor: const Color(0xFF2A1519),
            titleColor: Colors.redAccent,
            prices: prices2D,
          ),
        if (prices3D.isNotEmpty) ...[
          const SizedBox(height: 24),
          _PriceSection(
            title: 'Phim 3D',
            headerColor: const Color(0xFF151D33),
            titleColor: Colors.blueAccent,
            prices: prices3D,
          ),
        ],
        const SizedBox(height: 32),
        const _NotesSection(),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({
    required this.title,
    required this.headerColor,
    required this.titleColor,
    required this.prices,
  });

  final String title;
  final Color headerColor;
  final Color titleColor;
  final List<TicketPrice> prices;

  @override
  Widget build(BuildContext context) {
    // Extract unique time frames and sort them
    final timeFrames = prices
        .map((p) => '${p.startTime} - ${p.endTime}')
        .toSet()
        .toList();
    timeFrames.sort();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14), // Darker background for table
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: titleColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(0.8),
                3: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                    _TableHeader('Khung giờ'),
                    _TableHeader('Standard'),
                    _TableHeader('VIP'),
                    _TableHeader('Sweetbox'),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                  ],
                ),
                for (final timeFrame in timeFrames) ...[
                  _buildPriceRow(timeFrame),
                  if (timeFrame != timeFrames.last)
                    TableRow(
                      children: [
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildPriceRow(String timeFrame) {
    final framePrices = prices
        .where((p) => '${p.startTime} - ${p.endTime}' == timeFrame)
        .toList();

    int? getPrice(String seatType) {
      final p = framePrices.where((p) => p.typeSeat == seatType).firstOrNull;
      return p?.price;
    }

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    Widget buildPriceCell(int? price, Color color) {
      if (price == null) {
        return const Center(child: Text('-', style: TextStyle(color: Colors.white54)));
      }
      return Center(
        child: Text(
          currencyFormat.format(price).replaceAll(' đ', 'đ'),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }

    return TableRow(
      children: [
        Text(
          timeFrame,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        buildPriceCell(getPrice('STANDARD'), Colors.blue[400]!),
        buildPriceCell(getPrice('VIP'), Colors.amber[400]!),
        buildPriceCell(getPrice('SWEETBOX'), Colors.redAccent),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lưu ý',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _NoteItem('Giá vé hiển thị theo loại phim, loại ghế và khung giờ tương ứng.'),
          const SizedBox(height: 12),
          _NoteItem('Bảng giá được đồng bộ theo dữ liệu hiện hành của rạp.'),
          const SizedBox(height: 12),
          _NoteItem('Một số suất chiếu đặc biệt có thể có mức giá khác so với bảng tham khảo.'),
          const SizedBox(height: 12),
          _NoteItem('Vui lòng kiểm tra giá cuối cùng tại bước chọn ghế trước khi thanh toán.'),
        ],
      ),
    );
  }
}

class _NoteItem extends StatelessWidget {
  const _NoteItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6, right: 12),
          child: Icon(Icons.circle, size: 6, color: Colors.white54),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
