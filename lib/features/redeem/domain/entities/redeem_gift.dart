import 'package:mtbs_app/features/redeem/domain/entities/redeem.dart';

class RedeemGift {
  const RedeemGift({
    required this.id,
    required this.transactionNo,
    required this.amount,
    required this.status,
    this.redeem,
    this.address = '',
    this.phone = '',
    this.expectedDeliveryDate,
    this.deliveredAt,
    this.createdAt,
  });

  final String id;
  final String transactionNo;
  final int amount;
  final String status;
  final Redeem? redeem;
  final String address;
  final String phone;
  final DateTime? expectedDeliveryDate;
  final DateTime? deliveredAt;
  final DateTime? createdAt;

  int get spentPoints => (redeem?.pointsRequired ?? 0) * amount;
  bool get canCancel => status == 'PENDING';

  factory RedeemGift.fromJson(Map<String, dynamic> json) {
    final redeemJson = json['redeem'];
    return RedeemGift(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      transactionNo: (json['transactionNo'] ?? '').toString(),
      amount: _asInt(json['amount'], fallback: 1),
      status: (json['status'] ?? 'PENDING').toString(),
      redeem: redeemJson is Map<String, dynamic>
          ? Redeem.fromJson(redeemJson)
          : null,
      address: (json['address'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      expectedDeliveryDate: _asDate(json['expectedDeliveryDate']),
      deliveredAt: _asDate(json['deliveredAt']),
      createdAt: _asDate(json['createdAt']),
    );
  }

  static int _asInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static DateTime? _asDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
