import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'Thông tin tài khoản sẽ được hoàn thiện sau.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (user != null)
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
