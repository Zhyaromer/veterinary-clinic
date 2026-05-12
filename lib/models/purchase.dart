import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String id;
  final String ownerId;
  final String checkoutId;
  final String itemId;
  final String itemName;
  final String itemType; // food | toy | cage | medicine
  final double price;
  final int quantity;
  final String imageUrl;
  final DateTime purchasedAt;

  Purchase({
    required this.id,
    required this.ownerId,
    required this.checkoutId,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.purchasedAt,
  });

  double get subtotal => price * quantity;

  static DateTime _dateTimeFromAny(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  factory Purchase.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    final purchasedAt = _dateTimeFromAny(data['purchasedAt']);
    final purchasedAtClient = _dateTimeFromAny(data['purchasedAtClient']);

    return Purchase(
      id: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      checkoutId: data['checkoutId'] as String? ?? '',
      itemId: data['itemId'] as String? ?? '',
      itemName: data['itemName'] as String? ?? '',
      itemType: data['itemType'] as String? ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      quantity: (data['quantity'] as num? ?? 0).toInt(),
      imageUrl: data['imageUrl'] as String? ?? '',
      purchasedAt: purchasedAt.millisecondsSinceEpoch == 0
          ? purchasedAtClient
          : purchasedAt,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'ownerId': ownerId,
      'checkoutId': checkoutId,
      'itemId': itemId,
      'itemName': itemName,
      'itemType': itemType,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'purchasedAt': Timestamp.fromDate(purchasedAt),
      'purchasedAtClient': Timestamp.fromDate(purchasedAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
