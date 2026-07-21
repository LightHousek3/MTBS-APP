import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

final usersProvider = FutureProvider<List<AuthUser>>((ref) async {
  final controller = ref.read(authControllerProvider.notifier);
  return controller.getUsers();
});

class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: usersAsync.when(
        loading: () => const Center(child: AppHashLoader()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(usersProvider),
        ),
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('Chưa có người dùng nào.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserCard(user: user);
            },
          );
        },
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  const _UserCard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text('${user.firstName} ${user.lastName}'.trim()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(user.email),
            Text('Vai trò: ${user.role}'),
            Text('Trạng thái: ${user.status}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            await ref.read(authControllerProvider.notifier).changeUserStatus(
              userId: user.id,
              status: value,
            );
            if (context.mounted) {
              ref.invalidate(usersProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã cập nhật trạng thái người dùng')),
              );
            }
          },
          itemBuilder: (_) => const <PopupMenuEntry<String>>[
            PopupMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
            PopupMenuItem(value: 'INACTIVE', child: Text('INACTIVE')),
            PopupMenuItem(value: 'BLOCKED', child: Text('BLOCKED')),
          ],
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
