import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/features/booking/presentation/booking_navigation.dart';
import 'package:mtbs_app/features/showtimes/domain/entities/showtime.dart';
import 'package:mtbs_app/features/showtimes/presentation/view_models/showtime_controller.dart';

class TheaterShowtimesPage extends ConsumerStatefulWidget {
  const TheaterShowtimesPage({required this.theaterId, super.key});
  final String theaterId;
  @override
  ConsumerState<TheaterShowtimesPage> createState() =>
      _TheaterShowtimesPageState();
}

class _TheaterShowtimesPageState extends ConsumerState<TheaterShowtimesPage> {
  late DateTime _date;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final query = (theaterId: widget.theaterId, date: _date);
    final showtimes = ref.watch(theaterShowtimesProvider(query));
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch chiếu tại rạp')),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 74,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final normalized = DateTime(date.year, date.month, date.day);
                final selected = _sameDay(normalized, _date);
                return ChoiceChip(
                  selected: selected,
                  onSelected: (_) => setState(() => _date = normalized),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(index == 0 ? 'Hôm nay' : _weekday(date)),
                      Text(
                        DateFormat('dd/MM').format(date),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: showtimes.when(
              loading: () => const Center(child: AppHashLoader()),
              error: (error, _) => AsyncErrorView(
                error: error,
                onRetry: () => ref.invalidate(theaterShowtimesProvider(query)),
              ),
              data: (items) {
                final groups = <String, List<Showtime>>{};
                for (final item in items) {
                  groups
                      .putIfAbsent(
                        item.movie?.id ?? item.id,
                        () => <Showtime>[],
                      )
                      .add(item);
                }
                if (groups.isEmpty) {
                  return const Center(
                    child: Text('Không có suất chiếu trong ngày này.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: groups.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final group = groups.values.elementAt(index);
                    final movie = group.first.movie;
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16181E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 68,
                                  height: 96,
                                  child: movie?.imageUrl?.isNotEmpty == true
                                      ? CachedNetworkImage(
                                          imageUrl: movie!.imageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : const ColoredBox(
                                          color: Colors.black26,
                                          child: Icon(Icons.movie_outlined),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      movie?.title ?? 'Phim',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${movie?.ageRating ?? 'P'} • ${movie?.duration ?? 0} phút • ${movie?.type ?? '2D'}',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: group
                                .map(
                                  (showtime) => OutlinedButton(
                                    onPressed: () => startBookingFlow(
                                      context,
                                      ref,
                                      showtime.id,
                                    ),
                                    child: Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(showtime.startTime),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
String _weekday(DateTime date) =>
    date.weekday == DateTime.sunday ? 'Chủ nhật' : 'Thứ ${date.weekday + 1}';
