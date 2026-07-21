abstract final class AppRoutePaths {
  static const home = '/';
  static const theaters = '/theaters';
  static const ticketPrices = '/ticket-prices';
  static const promotions = '/promotions';
  static const news = '/news';
  static const festivals = '/festivals';
  static const account = '/account';

  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const forgotPassword = '/forgot-password';
  static const adminUsers = '/admin/users';
  static const movieDetail = '/movie/:movieId';
  static const theaterShowtimes = '/theaters/:theaterId/showtimes';
  static const seatSelection = '/booking/seats/:showtimeId';
  static const serviceSelection = '/booking/services';
  static const paymentRoute = '/payment/:bookingId';
  static const paymentResult = '/payment-result';
  static const redeems = '/redeems';
  static const redeemDetailPath = '/redeem/:redeemId';
  static const promotionDetailPath = '/promotion/:promotionId';
  static const newsDetailPath = '/news/:newsId';
  static const festivalDetailPath = '/festival/:festivalId';

  static String movie(String movieId) => '/movie/$movieId';
  static String showtimesAt(String theaterId) =>
      '/theaters/$theaterId/showtimes';
  static String seats(String showtimeId) => '/booking/seats/$showtimeId';
  static String payment(String bookingId) => '/payment/$bookingId';
  static String accountBookingHistory() => '$account?tab=bookings';
  static const services = serviceSelection;
  static String redeemDetail(String redeemId) => '/redeem/$redeemId';
  static String promotionDetail(String promotionId) =>
      '/promotion/$promotionId';
  static String newsDetail(String newsId) => '/news/$newsId';
  static String festivalDetail(String festivalId) => '/festival/$festivalId';
  static String loginFrom(String from) =>
      '$login?from=${Uri.encodeComponent(from)}';
  static String verifyEmailFor(String email) =>
      '$verifyEmail?email=${Uri.encodeComponent(email)}';

  static String? internalRedirect(String? value) {
    final redirect = value?.trim();
    if (redirect == null || redirect.isEmpty) return null;
    final uri = Uri.tryParse(redirect);
    if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
    if (!redirect.startsWith('/') || redirect.startsWith('//')) return null;
    return redirect;
  }
}
