import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _isSubmitting = false;
  String? _successMessage;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Quên mật khẩu')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: GradientButton.gradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.key_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quên mật khẩu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nhập email đã đăng ký để nhận hướng dẫn khôi phục tài khoản.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  enabled: !_isSubmitting,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!_isSubmitting) _submit();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Vui lòng nhập email';
                    if (!RegExp(
                      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                    ).hasMatch(email)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                GradientButton(
                  label: 'Gửi hướng dẫn đặt lại',
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  icon: const Icon(Icons.send_outlined, color: Colors.white),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _successMessage == null
                      ? const SizedBox.shrink()
                      : Padding(
                          key: ValueKey<String>(_successMessage!),
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF22C55E,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(
                                  0xFF22C55E,
                                ).withValues(alpha: 0.45),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF4ADE80),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_successMessage!)),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _isSubmitting
                      ? null
                      : () => context.go(AppRoutePaths.login),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Quay lại trang đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _successMessage = null;
    });
    final message = await ref
        .read(authControllerProvider.notifier)
        .forgotPassword(_email.text);
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _successMessage = message;
    });
    if (message == null) {
      final auth = ref.read(authControllerProvider);
      if (auth.hasError) showAppErrorSnackBar(context, auth.error!);
    }
  }
}
