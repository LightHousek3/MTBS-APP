import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/theaters/presentation/view_models/theater_locator_controller.dart';

class TheatersPage extends ConsumerWidget {
  const TheatersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locator = ref.watch(theaterLocatorControllerProvider);
    final current = locator.value ?? const TheaterLocatorState();

    return Scaffold(
      appBar: AppBar(title: Text('Tìm rạp')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 120),
          children: <Widget>[
            Text(
              'Nhập bán kính để tìm rạp gần bạn nhất',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white60),
            ),
            const SizedBox(height: 15),
            _RadiusSearchBar(state: current),
            const SizedBox(height: 16),
            _RadiusChips(state: current),
            const SizedBox(height: 24),
            locator.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 42),
                child: Center(child: AppHashLoader()),
              ),
              error: (error, _) => AsyncErrorView(
                error: error,
                onRetry: () => ref
                    .read(theaterLocatorControllerProvider.notifier)
                    .searchNearby(),
              ),
              data: (state) => _TheaterResults(state: state),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusSearchBar extends ConsumerStatefulWidget {
  const _RadiusSearchBar({required this.state});

  final TheaterLocatorState state;

  @override
  ConsumerState<_RadiusSearchBar> createState() => _RadiusSearchBarState();
}

class _RadiusSearchBarState extends ConsumerState<_RadiusSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.state.radiusKm}');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _RadiusSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        oldWidget.state.radiusKm != widget.state.radiusKm) {
      _controller.text = '${widget.state.radiusKm}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF15151C),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onSubmitted: (_) => _submit(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            decoration: const InputDecoration(
              filled: false,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              icon: Icon(Icons.navigation, color: Color(0xFFE30713), size: 24),
              suffixText: 'km',
              hintText: '1 - 150',
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      SizedBox.square(
        dimension: 56,
        child: GradientButton(
          label: '',
          icon: const Icon(Icons.search, color: Colors.white, size: 24),
          height: 56,
          borderRadius: 18,
          isLoading: widget.state.isSearching,
          onPressed: widget.state.isSearching ? null : _submit,
        ),
      ),
    ],
  );

  Future<void> _submit() async {
    final radius = int.tryParse(_controller.text.trim());
    if (radius == null ||
        radius < TheaterLocatorController.minRadiusKm ||
        radius > TheaterLocatorController.maxRadiusKm) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Bán kính phải từ 1 đến 150 km.')),
        );
      return;
    }
    _focusNode.unfocus();
    await ref
        .read(theaterLocatorControllerProvider.notifier)
        .searchNearby(radiusKm: radius);
  }
}

class _RadiusChips extends ConsumerWidget {
  const _RadiusChips({required this.state});

  final TheaterLocatorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: TheaterLocatorController.radiusOptions
        .map((radius) {
          final selected = radius == state.radiusKm;
          return ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('$radius km'),
            ),
            selected: selected,
            onSelected: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
              ref
                  .read(theaterLocatorControllerProvider.notifier)
                  .setRadius(radius);
            },
            selectedColor: const Color(0xFF2A1114),
            backgroundColor: const Color(0xFF141820),
            side: BorderSide(
              color: selected
                  ? const Color(0xFFE30713)
                  : Colors.white.withValues(alpha: 0.18),
            ),
            labelStyle: TextStyle(
              color: selected ? const Color(0xFFFF7777) : Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          );
        })
        .toList(growable: false),
  );
}

class _TheaterResults extends StatelessWidget {
  const _TheaterResults({required this.state});

  final TheaterLocatorState state;

  @override
  Widget build(BuildContext context) {
    if (state.theaters.isEmpty) {
      return Text(
        state.position == null
            ? 'Chọn bán kính và bấm tìm kiếm để bắt đầu.'
            : 'Không tìm thấy rạp trong bán kính ${state.radiusKm} km',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tìm thấy ${state.theaters.length} rạp trong bán kính ${state.radiusKm} km',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        for (final item in state.theaters) ...<Widget>[
          _TheaterCard(item: item),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _TheaterCard extends StatelessWidget {
  const _TheaterCard({required this.item});

  final TheaterDistance item;

  @override
  Widget build(BuildContext context) {
    final theater = item.theater;
    final phone = theater.phone?.isEmpty ?? true
        ? 'Chưa cập nhật'
        : theater.phone!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF08070D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE30713), width: 1.1),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 88,
                    height: 88,
                    color: Colors.black,
                    child: const Icon(
                      Icons.event_seat,
                      size: 42,
                      color: Color(0xFF6E1523),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        theater.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theater.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFFFF7777),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.distanceKm.isInfinite
                                ? 'N/A'
                                : '${item.distanceKm.toStringAsFixed(1)} km',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: const Color(0xFFFF7777),
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.phone_outlined,
                      color: Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(phone, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  children: <Widget>[
                    Chip(label: Text('2D')),
                    Chip(label: Text('3D')),
                  ],
                ),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Xem lịch chiếu',
                  height: 48,
                  borderRadius: 16,
                  onPressed: () =>
                      context.push(AppRoutePaths.showtimesAt(theater.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
