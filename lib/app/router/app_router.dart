import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtbs_app/app/router/app_route_paths.dart';
import 'package:mtbs_app/app/router/app_shell.dart';
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
import 'package:mtbs_app/features/profile/presentation/pages/admin_users_page.dart';
import 'package:mtbs_app/features/promotions/presentation/pages/promotion_detail_page.dart';
import 'package:mtbs_app/features/promotions/presentation/pages/promotion_list_page.dart';
import 'package:mtbs_app/features/redeem/presentation/pages/redeem_detail_page.dart';
import 'package:mtbs_app/features/redeem/presentation/pages/redeem_list_page.dart';
import 'package:mtbs_app/features/showtimes/presentation/pages/theater_showtimes_page.dart';
import 'package:mtbs_app/features/theaters/presentation/pages/theaters_page.dart';
import 'package:mtbs_app/features/ticket_prices/presentation/pages/ticket_prices_page.dart';

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
        builder: (_, state) => PaymentPage(
          bookingId: state.pathParameters['bookingId']!,
          initialResult: PaymentPageResultData.fromQueryParameters(
            state.uri.queryParameters,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.paymentResult,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (_, state) {
          final id = state.uri.queryParameters['bookingId'];
          if (id == null) return AppRoutePaths.home;

          final nextQuery = Map<String, String>.from(state.uri.queryParameters)
            ..remove('bookingId');
          final nextUri = Uri(
            path: AppRoutePaths.payment(id),
            queryParameters: nextQuery.isEmpty ? null : nextQuery,
          );
          return nextUri.toString();
        },
      ),
      GoRoute(
        path: AppRoutePaths.adminUsers,
        builder: (_, _) => const AdminUsersPage(),
      ),
      GoRoute(
        path: AppRoutePaths.redeems,
        builder: (_, _) => const RedeemListPage(),
      ),
      GoRoute(
        path: AppRoutePaths.redeemDetailPath,
        builder: (_, state) =>
            RedeemDetailPage(redeemId: state.pathParameters['redeemId']!),
      ),
      GoRoute(
        path: AppRoutePaths.promotionDetailPath,
        builder: (_, state) => PromotionDetailPage(
          promotionId: state.pathParameters['promotionId']!,
        ),
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
                builder: (_, _) => const TicketPricesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.promotions,
                builder: (_, _) => const PromotionListPage(),
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

@TypedGoRoute<RedeemListRoute>(path: AppRoutePaths.redeems)
class RedeemListRoute extends GoRouteData with $RedeemListRoute {
  const RedeemListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RedeemListPage();
}

@TypedGoRoute<RedeemDetailRoute>(path: AppRoutePaths.redeemDetailPath)
class RedeemDetailRoute extends GoRouteData with $RedeemDetailRoute {
  const RedeemDetailRoute({required this.redeemId});

  final String redeemId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RedeemDetailPage(redeemId: redeemId);
}
