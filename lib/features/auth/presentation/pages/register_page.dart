import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_logo.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  String _gender = 'OTHER';

  @override
  void dispose() {
    for (final controller in <TextEditingController>[
      _firstName,
      _lastName,
      _email,
      _password,
      _address,
      _phone,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo tài khoản')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  const AppLogo(width: 158, height: 62),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(child: _field(_firstName, 'Tên', maxLength: 10)),
                      const SizedBox(width: 12),
                      Expanded(child: _field(_lastName, 'Họ', maxLength: 10)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _email,
                    'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _field(_password, 'Mật khẩu', obscure: true),
                  const SizedBox(height: 12),
                  _field(_address, 'Địa chỉ'),
                  const SizedBox(height: 12),
                  _field(
                    _phone,
                    'Số điện thoại (không bắt buộc)',
                    required: false,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(labelText: 'Giới tính'),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: 'MALE', child: Text('Nam')),
                      DropdownMenuItem(value: 'FEMALE', child: Text('Nữ')),
                      DropdownMenuItem(value: 'OTHER', child: Text('Khác')),
                    ],
                    onChanged: (value) => _gender = value ?? 'OTHER',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      label: 'Đăng ký',
                      onPressed: auth.isLoading ? null : _submit,
                      isLoading: auth.isLoading,
                    ),
                  ),
                  if (auth.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        errorMessage(auth.error!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _field(
    TextEditingController controller,
    String label, {
    bool required = true,
    bool obscure = false,
    int? maxLength,
    TextInputType? keyboardType,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    maxLength: maxLength,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: label),
    validator: (value) => required && (value == null || value.trim().isEmpty)
        ? 'Vui lòng nhập $label'
        : null,
  );

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .register(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          gender: _gender,
          address: _address.text.trim(),
          phone: _phone.text.trim(),
        );
    if (ok && mounted) {
      context.go(AppRoutePaths.verifyEmailFor(_email.text.trim()));
    }
  }
}
