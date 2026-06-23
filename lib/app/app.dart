import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/app/router/app_router.dart';
import 'package:mtbs_app/app/theme/app_theme.dart';
import 'package:mtbs_app/core/config/app_config.dart';
import 'package:mtbs_app/features/booking/presentation/widgets/pending_booking_fab.dart';

class MtbsApp extends ConsumerWidget {
  const MtbsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    Future<void> openPayment(String bookingId) async {
      final location = AppRoutePaths.payment(bookingId);
      final routerContext = rootNavigatorKey.currentContext;
      if (routerContext != null && routerContext.mounted) {
        try {
          await GoRouter.of(routerContext).push(location);
          return;
        } catch (_) {
          // The global pending button is rendered by MaterialApp.builder, whose
          // context can sit outside GoRouter. Fall back to the router instance.
        }
      }
      await router.push(location);
    }

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) => ListenableBuilder(
        listenable: router.routeInformationProvider,
        builder: (context, _) {
          final path = router.routeInformationProvider.value.uri.path;
          final showPendingPayment = !path.startsWith('/payment/');
          return Stack(
            children: <Widget>[
              child ?? const SizedBox.shrink(),
              if (showPendingPayment)
                Positioned(
                  right: 16,
                  bottom: MediaQuery.paddingOf(context).bottom + 88,
                  child: PendingBookingFab(
                    onOpenPayment: (bookingId) =>
                        unawaited(openPayment(bookingId)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
