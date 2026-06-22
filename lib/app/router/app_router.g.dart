// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $registerRoute,
  $verifyEmailRoute,
  $forgotPasswordRoute,
  $movieDetailRoute,
  $redeemListRoute,
  $redeemDetailRoute,
];

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) =>
      LoginRoute(from: state.uri.queryParameters['from']);

  LoginRoute get _self => this as LoginRoute;

  @override
  String get location => GoRouteData.$location(
    '/login',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute =>
    GoRouteData.$route(path: '/register', factory: $RegisterRoute._fromState);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verifyEmailRoute => GoRouteData.$route(
  path: '/verify-email',
  factory: $VerifyEmailRoute._fromState,
);

mixin $VerifyEmailRoute on GoRouteData {
  static VerifyEmailRoute _fromState(GoRouterState state) =>
      VerifyEmailRoute(email: state.uri.queryParameters['email']!);

  VerifyEmailRoute get _self => this as VerifyEmailRoute;

  @override
  String get location => GoRouteData.$location(
    '/verify-email',
    queryParams: {'email': _self.email},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $movieDetailRoute => GoRouteData.$route(
  path: '/movie/:movieId',
  factory: $MovieDetailRoute._fromState,
);

mixin $MovieDetailRoute on GoRouteData {
  static MovieDetailRoute _fromState(GoRouterState state) =>
      MovieDetailRoute(movieId: state.pathParameters['movieId']!);

  MovieDetailRoute get _self => this as MovieDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/movie/${Uri.encodeComponent(_self.movieId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $redeemListRoute =>
    GoRouteData.$route(path: '/redeems', factory: $RedeemListRoute._fromState);

mixin $RedeemListRoute on GoRouteData {
  static RedeemListRoute _fromState(GoRouterState state) =>
      const RedeemListRoute();

  @override
  String get location => GoRouteData.$location('/redeems');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $redeemDetailRoute => GoRouteData.$route(
  path: '/redeem/:redeemId',
  factory: $RedeemDetailRoute._fromState,
);

mixin $RedeemDetailRoute on GoRouteData {
  static RedeemDetailRoute _fromState(GoRouterState state) =>
      RedeemDetailRoute(redeemId: state.pathParameters['redeemId']!);

  RedeemDetailRoute get _self => this as RedeemDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/redeem/${Uri.encodeComponent(_self.redeemId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
