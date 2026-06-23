abstract final class AppRoutePaths {
  static const home = '/';
  static const theaters = '/theaters';
  static const ticketPrices = '/ticket-prices';
  static const promotions = '/promotions';
  static const account = '/account';

  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const forgotPassword = '/forgot-password';
  static const movieDetail = '/movie/:movieId';
  static const theaterShowtimes = '/theaters/:theaterId/showtimes';
  static const seatSelection = '/booking/seats/:showtimeId';
  static const serviceSelection = '/booking/services';
  static const paymentRoute = '/payment/:bookingId';
  static const paymentResult = '/payment-result';

  static String movie(String movieId) => '/movie/$movieId';
  static String showtimesAt(String theaterId) =>
      '/theaters/$theaterId/showtimes';
  static String seats(String showtimeId) => '/booking/seats/$showtimeId';
  static String payment(String bookingId) => '/payment/$bookingId';
  static const services = serviceSelection;
  static String loginFrom(String from) =>
      '$login?from=${Uri.encodeComponent(from)}';
  static String verifyEmailFor(String email) =>
      '$verifyEmail?email=${Uri.encodeComponent(email)}';
}
