import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({required this.email, super.key});
  final String email;
  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final _code = TextEditingController();
  bool _busy = false;
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Xác thực email')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Mã 6 số đã được gửi tới ${widget.email}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _code,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Mã xác thực'),
              ),
              GradientButton(
                label: 'Xác thực',
                onPressed: _busy ? null : _verify,
                isLoading: _busy,
              ),
              TextButton(
                onPressed: () => ref
                    .read(authRepositoryProvider)
                    .resendVerification(widget.email),
                child: const Text('Gửi lại mã'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _verify() async {
    setState(() => _busy = true);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .verifyEmail(widget.email, _code.text.trim());
    if (mounted) setState(() => _busy = false);
    if (ok && mounted) context.go(AppRoutePaths.login);
  }
}
