import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final email = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Quên mật khẩu')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          TextField(
            controller: email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Gửi hướng dẫn',
            onPressed: () async {
              await ref
                  .read(authRepositoryProvider)
                  .forgotPassword(email.text.trim());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nếu email tồn tại, hướng dẫn đã được gửi.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}
