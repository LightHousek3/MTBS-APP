import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = switch (ref.watch(authControllerProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tài Khoản')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.person_outline, size: 82),
              const SizedBox(height: 18),
              Text(
                user == null ? 'Tài Khoản' : user.fullName,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'Thông tin tài khoản sẽ được hoàn thiện sau.',
                textAlign: TextAlign.center,
              ),
              if (user != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.stars_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${user.loyaltyPoints} điểm tích lũy',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutePaths.redeems),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Đổi quà'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(180, 48),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

