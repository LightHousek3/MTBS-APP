import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtbs_app/app/app.dart';
import 'package:mtbs_app/core/di/core_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(sessionStoreProvider).initialize();
  runApp(
    UncontrolledProviderScope(container: container, child: const MtbsApp()),
  );
}
