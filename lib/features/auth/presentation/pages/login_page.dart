import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:mtbs_app/core/widgets/app_logo.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({this.redirect, super.key});
  final String? redirect;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  _SocialProvider? _activeSocialProvider;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(next.error!))));
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
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
                  const Center(child: AppLogo(width: 168, height: 68)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) => value != null && value.contains('@')
                        ? null
                        : 'Email không hợp lệ',
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    autofillHints: const <String>[AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) => (value?.length ?? 0) >= 6
                        ? null
                        : 'Mật khẩu tối thiểu 6 ký tự',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.push(AppRoutePaths.forgotPassword),
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ),
                  GradientButton(
                    label: 'Đăng nhập',
                    onPressed: auth.isLoading ? null : _submit,
                    isLoading: auth.isLoading && _activeSocialProvider == null,
                  ),
                  if (!kIsWeb) ...<Widget>[
                    const SizedBox(height: 20),
                    const Row(
                      children: <Widget>[
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Hoặc tiếp tục với'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _SocialLoginButton(
                            label: 'Google',
                            symbol: 'G',
                            symbolColor: const Color(0xFF4285F4),
                            isLoading:
                                _activeSocialProvider == _SocialProvider.google,
                            onPressed: auth.isLoading
                                ? null
                                : () => _socialLogin(_SocialProvider.google),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SocialLoginButton(
                            label: 'Facebook',
                            symbol: 'f',
                            symbolColor: const Color(0xFF1877F2),
                            isLoading:
                                _activeSocialProvider ==
                                _SocialProvider.facebook,
                            onPressed: auth.isLoading
                                ? null
                                : () => _socialLogin(_SocialProvider.facebook),
                          ),
                        ),
                      ],
                    ),
                  ],
                  TextButton(
                    onPressed: () => context.push(AppRoutePaths.register),
                    child: const Text('Chưa có tài khoản? Đăng ký'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .login(email: _email.text, password: _password.text);
    if (ok && mounted) context.go(widget.redirect ?? AppRoutePaths.home);
  }

  Future<void> _socialLogin(_SocialProvider provider) async {
    setState(() => _activeSocialProvider = provider);
    final controller = ref.read(authControllerProvider.notifier);
    final ok = switch (provider) {
      _SocialProvider.google => await controller.loginWithGoogle(),
      _SocialProvider.facebook => await controller.loginWithFacebook(),
    };
    if (!mounted) return;
    setState(() => _activeSocialProvider = null);
    if (ok) context.go(widget.redirect ?? AppRoutePaths.home);
  }
}

enum _SocialProvider { google, facebook }

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.symbol,
    required this.symbolColor,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final String symbol;
  final Color symbolColor;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: const BorderSide(color: Colors.white24),
    ),
    child: isLoading
        ? const AppHashLoader(size: 22)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                symbol,
                style: TextStyle(
                  color: symbolColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
  );
}
