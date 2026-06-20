import 'package:flutter/material.dart';
import 'package:mtbs_app/core/errors/app_exception.dart';
import 'package:mtbs_app/core/widgets/gradient_button.dart';

String errorMessage(Object error) => switch (error) {
  AppException() => error.message,
  _ => 'Đã xảy ra lỗi. Vui lòng thử lại.',
};

class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(errorMessage(error), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(
            width: 148,
            child: GradientButton(
              label: 'Thử lại',
              onPressed: onRetry,
              height: 44,
              borderRadius: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
