import 'package:flutter/material.dart';
import 'package:mtbs_app/core/widgets/async_error_view.dart';

void showAppErrorSnackBar(BuildContext context, Object error) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
}
