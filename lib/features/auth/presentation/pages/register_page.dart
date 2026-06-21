import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/core/widgets/app_snack_bar.dart';
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
  final _confirmPassword = TextEditingController();
  final _address = TextEditingController();
  final _age = TextEditingController();
  final _phone = TextEditingController();
  String _gender = 'OTHER';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    for (final controller in <TextEditingController>[
      _firstName,
      _lastName,
      _email,
      _password,
      _confirmPassword,
      _address,
      _age,
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
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: .centerLeft,
                    child: Text(
                      'Tạo tài khoản mới và bắt đầu đặt vé xem phim',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _field(
                          _firstName,
                          'Tên',
                          icon: Icons.account_circle_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _lastName,
                          'Họ',
                          icon: Icons.account_circle_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Giới tính',
                      prefixIcon: Icon(Icons.people_outline),
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: 'MALE', child: Text('Nam')),
                      DropdownMenuItem(value: 'FEMALE', child: Text('Nữ')),
                      DropdownMenuItem(value: 'OTHER', child: Text('Khác')),
                    ],
                    onChanged: (value) => _gender = value ?? 'OTHER',
                  ),
                  const SizedBox(height: 20),
                  _field(_address, 'Địa chỉ', icon: Icons.location_on_outlined),
                  const SizedBox(height: 12),
                  _field(
                    _age,
                    'Tuổi',
                    icon: Icons.date_range_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tuổi';
                      }

                      final age = int.tryParse(value);

                      if (age == null) {
                        return 'Tuổi phải là số';
                      }

                      if (age < 13 || age > 120) {
                        return 'Tuổi không hợp lệ';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _phone,
                    'Số điện thoại',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }

                      final phone = value.trim();

                      final phoneRegex = RegExp(
                        r'^(?:\+84|84|0)(3|5|7|8|9)\d{8}$',
                      );

                      if (!phoneRegex.hasMatch(phone)) {
                        return 'Số điện thoại không hợp lệ';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _email,
                    'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập email';
                      }

                      final emailRegex = RegExp(
                        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                      );

                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Email không hợp lệ';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _password,
                    'Mật khẩu',
                    icon: Icons.lock_outline,
                    obscure: _obscurePassword,
                    onToggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }

                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _confirmPassword,
                    'Xác nhận mật khẩu',
                    icon: Icons.lock_outline,
                    obscure: _obscureConfirmPassword,
                    onToggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      }

                      if (value != _password.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      label: 'Đăng ký',
                      onPressed: auth.isLoading ? null : _submit,
                      isLoading: auth.isLoading,
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
    IconData? icon,
    bool required = true,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    maxLength: maxLength,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: onToggleObscure != null
          ? IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onToggleObscure,
            )
          : null,
    ),
    validator:
        validator ??
        (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
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
          age: int.tryParse(_age.text) ?? 0,
          phone: _phone.text.trim(),
        );
    if (ok && mounted) {
      context.go(AppRoutePaths.verifyEmailFor(_email.text.trim()));
    } else if (!ok && mounted) {
      final auth = ref.read(authControllerProvider);
      if (auth.hasError) showAppErrorSnackBar(context, auth.error!);
    }
  }
}
