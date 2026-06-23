import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/app/router/app_shell.dart';
import 'package:mtbs_app/app/router/placeholder_page.dart';
import 'package:mtbs_app/app/router/route_guard.dart';
import 'package:mtbs_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mtbs_app/features/auth/presentation/pages/login_page.dart';
import 'package:mtbs_app/features/auth/presentation/pages/register_page.dart';
import 'package:mtbs_app/features/auth/presentation/pages/verify_email_page.dart';
import 'package:mtbs_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:mtbs_app/features/booking/presentation/pages/payment_page.dart';
import 'package:mtbs_app/features/booking/presentation/pages/seat_selection_page.dart';
import 'package:mtbs_app/features/booking/presentation/pages/service_selection_page.dart';
import 'package:mtbs_app/features/home/presentation/pages/home_page.dart';
import 'package:mtbs_app/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:mtbs_app/features/profile/presentation/pages/profile_page.dart';
import 'package:mtbs_app/features/showtimes/presentation/pages/theater_showtimes_page.dart';
import 'package:mtbs_app/features/theaters/presentation/pages/theaters_page.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier();
  ref
    ..onDispose(refreshNotifier.dispose)
    ..listen(authControllerProvider, (_, _) {
      refreshNotifier.refresh();
    });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutePaths.home,
    refreshListenable: refreshNotifier,
    routes: <RouteBase>[
      ...$appRoutes,
      GoRoute(
        path: AppRoutePaths.theaterShowtimes,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) =>
            TheaterShowtimesPage(theaterId: state.pathParameters['theaterId']!),
      ),
      GoRoute(
        path: AppRoutePaths.seatSelection,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) =>
            SeatSelectionPage(showtimeId: state.pathParameters['showtimeId']!),
      ),
      GoRoute(
        path: AppRoutePaths.serviceSelection,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const ServiceSelectionPage(),
      ),
      GoRoute(
        path: AppRoutePaths.paymentRoute,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) =>
            PaymentPage(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        path: AppRoutePaths.paymentResult,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (_, state) {
          final id = state.uri.queryParameters['bookingId'];
          return id == null ? AppRoutePaths.home : AppRoutePaths.payment(id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.home,
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.theaters,
                builder: (_, _) => const TheatersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.ticketPrices,
                builder: (_, _) => const PlaceholderPage(
                  title: 'Giá Vé',
                  icon: Icons.local_activity,
                  description: 'Bảng giá vé đang được chuẩn hóa.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.promotions,
                builder: (_, _) => const PlaceholderPage(
                  title: 'Khuyến Mãi',
                  icon: Icons.card_giftcard,
                  description: 'Ưu đãi chi tiết sẽ được mở ở phiên bản sau.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.account,
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      return RouteGuard.redirect(
        authState: ref.read(authControllerProvider),
        state: state,
      );
    },
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy')),
      body: Center(
        child: Text(state.error?.toString() ?? 'Trang không tồn tại'),
      ),
    ),
  );
});

@TypedGoRoute<LoginRoute>(path: AppRoutePaths.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute({this.from});

  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LoginPage(redirect: from);
}

@TypedGoRoute<RegisterRoute>(path: AppRoutePaths.register)
class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterPage();
}

@TypedGoRoute<VerifyEmailRoute>(path: AppRoutePaths.verifyEmail)
class VerifyEmailRoute extends GoRouteData with $VerifyEmailRoute {
  const VerifyEmailRoute({required this.email});

  final String email;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      VerifyEmailPage(email: email);
}

@TypedGoRoute<ForgotPasswordRoute>(path: AppRoutePaths.forgotPassword)
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordPage();
}

@TypedGoRoute<MovieDetailRoute>(path: AppRoutePaths.movieDetail)
class MovieDetailRoute extends GoRouteData with $MovieDetailRoute {
  const MovieDetailRoute({required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MovieDetailPage(movieId: movieId);
}
