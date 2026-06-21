import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_logo.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({required this.email, super.key});

  final String email;

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  static const _resendCooldown = Duration(seconds: 60);
  static const _loginRedirectDelay = Duration(seconds: 5);

  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  Timer? _countdownTimer;
  Timer? _redirectTimer;
  late DateTime _resendAvailableAt;
  DateTime? _loginRedirectAt;
  int _secondsRemaining = _resendCooldown.inSeconds;
  int _loginSecondsRemaining = _loginRedirectDelay.inSeconds;
  bool _isVerifying = false;
  bool _isResending = false;
  bool _isVerified = false;
  bool _hasNavigated = false;

  bool get _canResend =>
      !_isVerified && _secondsRemaining == 0 && !_isResending;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _redirectTimer?.cancel();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Xác thực email')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(child: AppLogo(width: 168, height: 68)),
                const SizedBox(height: 20),
                Text(
                  'Mã 6 số đã được gửi tới ${widget.email}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng kiểm tra hộp thư và nhập mã để kích hoạt tài khoản.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isVerified
                      ? _VerificationSuccess(
                          secondsRemaining: _loginSecondsRemaining,
                          onLoginNow: _goToLogin,
                        )
                      : Column(
                          key: const ValueKey<String>('verification-form'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              controller: _code,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofillHints: const <String>[
                                AutofillHints.oneTimeCode,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Mã xác thực',
                                prefixIcon: Icon(Icons.verified_user_outlined),
                              ),
                              validator: (value) =>
                                  RegExp(r'^\d{6}$').hasMatch(value ?? '')
                                  ? null
                                  : 'Mã xác thực phải gồm đúng 6 chữ số',
                            ),
                            const SizedBox(height: 4),
                            GradientButton(
                              label: 'Xác thực',
                              onPressed: _isVerifying || _isResending
                                  ? null
                                  : _verify,
                              isLoading: _isVerifying,
                            ),
                            const SizedBox(height: 10),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _canResend ? 1 : 0.45,
                              child: TextButton(
                                onPressed: _canResend
                                    ? _resendVerification
                                    : null,
                                child: Text(
                                  _secondsRemaining > 0
                                      ? 'Gửi lại mã (${_secondsRemaining}s)'
                                      : _isResending
                                      ? 'Đang gửi lại mã...'
                                      : 'Gửi lại mã',
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  void _startResendCooldown() {
    _countdownTimer?.cancel();
    _resendAvailableAt = DateTime.now().add(_resendCooldown);
    _secondsRemaining = _resendCooldown.inSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final milliseconds = _resendAvailableAt
          .difference(DateTime.now())
          .inMilliseconds;
      final nextSeconds = milliseconds <= 0
          ? 0
          : (milliseconds / Duration.millisecondsPerSecond).ceil();
      if (!mounted) return;
      setState(() => _secondsRemaining = nextSeconds);
      if (nextSeconds == 0) _countdownTimer?.cancel();
    });
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isVerifying = true);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .verifyEmail(widget.email, _code.text.trim());
    if (!mounted) return;
    if (ok) {
      _showVerificationSuccess();
    } else {
      setState(() => _isVerifying = false);
      _showCurrentError();
    }
  }

  Future<void> _resendVerification() async {
    if (!_canResend) return;
    setState(() => _isResending = true);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .resendVerification(widget.email);
    if (!mounted) return;
    setState(() => _isResending = false);
    if (ok) {
      _startResendCooldown();
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Mã xác thực mới đã được gửi.')),
        );
    } else {
      _showCurrentError();
    }
  }

  void _showCurrentError() {
    final auth = ref.read(authControllerProvider);
    if (auth.hasError) showAppErrorSnackBar(context, auth.error!);
  }

  void _showVerificationSuccess() {
    _countdownTimer?.cancel();
    _loginRedirectAt = DateTime.now().add(_loginRedirectDelay);
    setState(() {
      _isVerifying = false;
      _isVerified = true;
      _loginSecondsRemaining = _loginRedirectDelay.inSeconds;
    });
    _redirectTimer?.cancel();
    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final redirectAt = _loginRedirectAt;
      if (!mounted || redirectAt == null) return;
      final milliseconds = redirectAt.difference(DateTime.now()).inMilliseconds;
      final nextSeconds = milliseconds <= 0
          ? 0
          : (milliseconds / Duration.millisecondsPerSecond).ceil();
      if (nextSeconds == 0) {
        _goToLogin();
      } else {
        setState(() => _loginSecondsRemaining = nextSeconds);
      }
    });
  }

  void _goToLogin() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _redirectTimer?.cancel();
    context.go(AppRoutePaths.login);
  }
}

class _VerificationSuccess extends StatelessWidget {
  const _VerificationSuccess({
    required this.secondsRemaining,
    required this.onLoginNow,
  });

  final int secondsRemaining;
  final VoidCallback onLoginNow;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey<String>('verification-success'),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF22C55E).withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xFF22C55E).withValues(alpha: 0.45),
      ),
    ),
    child: Column(
      children: <Widget>[
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF4ADE80),
          size: 52,
        ),
        const SizedBox(height: 12),
        Text(
          'Xác thực thành công',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Bạn sẽ được chuyển đến trang đăng nhập sau ${secondsRemaining}s.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onLoginNow, child: const Text('Đăng nhập ngay')),
      ],
    ),
  );
}
