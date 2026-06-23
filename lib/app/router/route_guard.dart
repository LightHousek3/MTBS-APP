import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/features/auth/domain/entities/auth_user.dart';

enum RouteAccess { public, guestOnly, authenticated }

final class GuardedPath {
  const GuardedPath.exact(this.path, this.access) : prefix = false;
  const GuardedPath.prefix(this.path, this.access) : prefix = true;

  final String path;
  final RouteAccess access;
  final bool prefix;

  bool matches(String location) =>
      prefix ? location.startsWith(path) : location == path;
}

abstract final class RouteAccessRegistry {
  static const routes = <GuardedPath>[
    GuardedPath.exact(AppRoutePaths.login, RouteAccess.guestOnly),
    GuardedPath.exact(AppRoutePaths.register, RouteAccess.guestOnly),
    GuardedPath.exact(AppRoutePaths.verifyEmail, RouteAccess.guestOnly),
    GuardedPath.exact(AppRoutePaths.forgotPassword, RouteAccess.guestOnly),
    GuardedPath.exact(AppRoutePaths.account, RouteAccess.authenticated),
    GuardedPath.prefix('/booking/', RouteAccess.authenticated),
    GuardedPath.prefix('/payment', RouteAccess.authenticated),
  ];

  static RouteAccess accessFor(String location) {
    for (final route in routes) {
      if (route.matches(location)) return route.access;
    }
    return RouteAccess.public;
  }
}

abstract final class RouteGuard {
  static String? redirect({
    required AsyncValue<AuthUser?> authState,
    required GoRouterState state,
  }) {
    if (authState.isLoading) return null;

    final location = state.uri.path;
    final access = RouteAccessRegistry.accessFor(location);
    final isAuthenticated = switch (authState) {
      AsyncData(:final value) => value != null,
      _ => false,
    };

    return switch ((access, isAuthenticated)) {
      (RouteAccess.authenticated, false) => AppRoutePaths.loginFrom(
        state.uri.toString(),
      ),
      (RouteAccess.guestOnly, true) => AppRoutePaths.home,
      _ => null,
    };
  }
}
