class SeatingData {
  const SeatingData({
    required this.showtime,
    required this.movie,
    required this.theater,
    required this.screenName,
    required this.seats,
    this.promotion,
  });

  final BookingShowtime showtime;
  final BookingMovie movie;
  final BookingTheater theater;
  final String screenName;
  final List<CinemaSeat> seats;
  final SeatingPromotion? promotion;

  factory SeatingData.fromJson(Map<String, dynamic> json) => SeatingData(
    showtime: BookingShowtime.fromJson(_map(json['showtime'])),
    movie: BookingMovie.fromJson(_map(json['movie'])),
    theater: BookingTheater.fromJson(_map(json['theater'])),
    screenName: _string(_map(json['screen'])['name']),
    seats: _list(
      json['seats'],
    ).map((item) => CinemaSeat.fromJson(_map(item))).toList(),
    promotion: _map(json['promotion']).isEmpty
        ? null
        : SeatingPromotion.fromJson(_map(json['promotion'])),
  );

  PriceSummary priceForSeats(Iterable<CinemaSeat> selectedSeats) {
    final seats = selectedSeats.toList(growable: false);
    final baseTotal = seats.fold<double>(
      0,
      (total, seat) => total + seat.basePrice,
    );
    final eligibleTotal = seats
        .where((seat) => seat.promotionEligible)
        .fold<double>(0, (total, seat) => total + seat.basePrice);
    final activePromotion = promotion;
    if (activePromotion == null || eligibleTotal == 0) {
      return PriceSummary(base: baseTotal, finalPrice: baseTotal);
    }

    final discount = activePromotion.discountType == 'PERCENT'
        ? (eligibleTotal * activePromotion.discountValue / 100).roundToDouble()
        : activePromotion.discountValue.clamp(0, eligibleTotal);
    return PriceSummary(base: baseTotal, finalPrice: baseTotal - discount);
  }
}

class SeatingPromotion {
  const SeatingPromotion({
    required this.discountType,
    required this.discountValue,
  });
  final String discountType;
  final double discountValue;
  factory SeatingPromotion.fromJson(Map<String, dynamic> json) =>
      SeatingPromotion(
        discountType: _string(json['discountType']),
        discountValue: _double(json['discountValue']),
      );
}

class PriceSummary {
  const PriceSummary({required this.base, required this.finalPrice});
  final double base;
  final double finalPrice;
  bool get hasDiscount => finalPrice < base;
}

class CinemaSeat {
  const CinemaSeat({
    required this.id,
    required this.number,
    required this.type,
    required this.status,
    required this.basePrice,
    required this.price,
    required this.discount,
    required this.promotionEligible,
  });
  final String id;
  final String number;
  final String type;
  final String status;
  final double basePrice;
  final double price;
  final double discount;
  final bool promotionEligible;
  bool get isAvailable => status == 'AVAILABLE';

  factory CinemaSeat.fromJson(Map<String, dynamic> json) => CinemaSeat(
    id: _id(json),
    number: _string(json['seatNumber']),
    type: _string(json['type']),
    status: _string(json['status']),
    basePrice: _double(json['basePrice'] ?? json['price']),
    price: _double(json['price']),
    discount: _double(json['discount']),
    promotionEligible: json['promotionEligible'] == true,
  );
}

class CinemaService {
  const CinemaService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;

  factory CinemaService.fromJson(Map<String, dynamic> json) => CinemaService(
    id: _id(json),
    name: _string(json['name']),
    description: _string(json['description']),
    price: _double(json['price']),
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    imageUrl: json['imageUrl']?.toString(),
  );
}

class BookingMovie {
  const BookingMovie({
    required this.id,
    required this.title,
    required this.type,
    this.imageUrl,
  });
  final String id;
  final String title;
  final String type;
  final String? imageUrl;
  factory BookingMovie.fromJson(Map<String, dynamic> json) => BookingMovie(
    id: _id(json),
    title: _string(json['title']),
    type: _string(json['type']),
    imageUrl: _map(json['image'])['url']?.toString(),
  );
}

class BookingTheater {
  const BookingTheater({
    required this.id,
    required this.name,
    required this.address,
  });
  final String id;
  final String name;
  final String address;
  factory BookingTheater.fromJson(Map<String, dynamic> json) => BookingTheater(
    id: _id(json),
    name: _string(json['name']),
    address: _string(json['address']),
  );
}

class BookingShowtime {
  const BookingShowtime({
    required this.id,
    required this.startTime,
    this.movie,
    this.theater,
    this.screenName = '',
  });
  final String id;
  final DateTime startTime;
  final BookingMovie? movie;
  final BookingTheater? theater;
  final String screenName;
  factory BookingShowtime.fromJson(Map<String, dynamic> json) {
    final screen = _map(json['screen']);
    final movie = _map(json['movie']);
    final theater = _map(screen['theater']);
    return BookingShowtime(
      id: _id(json),
      startTime:
          DateTime.tryParse(_string(json['startTime']))?.toLocal() ??
          DateTime.now(),
      movie: movie.isEmpty ? null : BookingMovie.fromJson(movie),
      theater: theater.isEmpty ? null : BookingTheater.fromJson(theater),
      screenName: _string(screen['name']),
    );
  }
}

class Booking {
  const Booking({
    required this.id,
    required this.showtime,
    required this.seats,
    required this.services,
    required this.status,
    required this.totalPriceMovie,
    required this.totalPriceService,
    required this.pointsUsed,
    required this.pointsEarned,
    required this.totalPrice,
    required this.createdAt,
    required this.expiresAt,
    this.qrCode,
  });
  final String id;
  final BookingShowtime showtime;
  final List<BookingSeatLine> seats;
  final List<BookingServiceLine> services;
  final String status;
  final double totalPriceMovie;
  final double totalPriceService;
  final int pointsUsed;
  final int pointsEarned;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? qrCode;
  bool get isPending =>
      status == 'PENDING' && expiresAt.isAfter(DateTime.now());

  factory Booking.fromJson(Map<String, dynamic> json) {
    final seats = _list(
      json['seats'],
    ).map((item) => BookingSeatLine.fromJson(_map(item))).toList();
    final services = _list(
      json['services'],
    ).map((item) => BookingServiceLine.fromJson(_map(item))).toList();
    final movieTotal = _double(json['totalPriceMovie']);
    final serviceAmount = _double(json['totalPriceService']);
    final pointsUsed = (json['pointsUsed'] as num?)?.toInt() ?? 0;
    return Booking(
      id: _id(json),
      showtime: BookingShowtime.fromJson(_map(json['showtime'])),
      seats: seats,
      services: services,
      status: _string(json['status']),
      totalPriceMovie: movieTotal == 0 && seats.isNotEmpty
          ? seats.fold<double>(0, (sum, seat) => sum + seat.finalPrice)
          : movieTotal,
      totalPriceService: serviceAmount == 0 && services.isNotEmpty
          ? services.fold<double>(0, (sum, service) => sum + service.finalTotal)
          : serviceAmount,
      pointsUsed: pointsUsed,
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
      totalPrice: _double(json['totalPrice']),
      qrCode: json['qrCode']?.toString(),
      createdAt:
          DateTime.tryParse(_string(json['createdAt']))?.toLocal() ??
          DateTime.now(),
      expiresAt:
          DateTime.tryParse(_string(json['expiresAt']))?.toLocal() ??
          DateTime.now(),
    );
  }

  List<String> get seatNumbers => seats.map((seat) => seat.number).toList();
  double get movieBaseTotal =>
      seats.fold<double>(0, (sum, seat) => sum + seat.basePrice);
  double get serviceBaseTotal =>
      services.fold<double>(0, (sum, service) => sum + service.baseTotal);
  double get baseTotal => movieBaseTotal + serviceBaseTotal;
  double get ticketFinalTotal => totalPriceMovie > 0
      ? totalPriceMovie
      : seats.fold<double>(0, (sum, seat) => sum + seat.finalPrice);
  double get concessionFinalTotal => totalPriceService > 0
      ? totalPriceService
      : services.fold<double>(0, (sum, service) => sum + service.finalTotal);
  double get payableTotal {
    if (totalPrice > 0) return totalPrice;
    final total = ticketFinalTotal + concessionFinalTotal - pointsUsed;
    return total < 0 ? 0 : total;
  }
}

class BookingSeatLine {
  const BookingSeatLine({
    required this.number,
    required this.basePrice,
    required this.finalPrice,
  });
  final String number;
  final double basePrice;
  final double finalPrice;
  factory BookingSeatLine.fromJson(Map<String, dynamic> json) =>
      BookingSeatLine(
        number: _string(_map(json['seat'])['seatNumber']),
        basePrice: _double(json['price']),
        finalPrice: _double(json['finalPrice'] ?? json['price']),
      );
}

class BookingServiceLine {
  const BookingServiceLine({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.baseTotal,
    required this.finalTotal,
  });
  final String name;
  final int quantity;
  final double unitPrice;
  final double baseTotal;
  final double finalTotal;
  factory BookingServiceLine.fromJson(Map<String, dynamic> json) {
    final quantity = (json['quantity'] as num?)?.toInt() ?? 0;
    final unitPrice = _double(
      json['unitPrice'] ?? _map(json['service'])['price'],
    );
    final baseTotal = _double(json['total']);
    return BookingServiceLine(
      name: _string(_map(json['service'])['name']),
      quantity: quantity,
      unitPrice: unitPrice,
      baseTotal: baseTotal > 0 ? baseTotal : unitPrice * quantity,
      finalTotal: _double(
        json['finalTotal'] ??
            (baseTotal > 0 ? baseTotal : unitPrice * quantity),
      ),
    );
  }
}

class BookingDraft {
  const BookingDraft({required this.seating, required this.selectedSeats});
  final SeatingData seating;
  final List<CinemaSeat> selectedSeats;
  PriceSummary get seatPricing => seating.priceForSeats(selectedSeats);
  double get ticketTotal => seatPricing.finalPrice;
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};
List<Object?> _list(Object? value) =>
    value is List<Object?> ? value : const <Object?>[];
String _string(Object? value) => value?.toString() ?? '';
String _id(Map<String, dynamic> json) => _string(json['id'] ?? json['_id']);
double _double(Object? value) => (value as num?)?.toDouble() ?? 0;
