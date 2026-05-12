import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/cart_item.dart';
import '../models/purchase.dart';

class PurchasesFirestoreService {
  static final PurchasesFirestoreService _instance =
      PurchasesFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory PurchasesFirestoreService() {
    return _instance;
  }

  PurchasesFirestoreService._internal();

  final String _collectionName = 'purchases';

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase has not been initialized');
    }

    _firestore = FirebaseFirestore.instance;
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    _isInitialized = true;
  }

  Stream<List<Purchase>> getPurchasesStream() async* {
    await _ensureInitialized();

    yield* _firestore.collection(_collectionName).snapshots().map((snapshot) {
      final purchases = snapshot.docs.map((doc) => Purchase.fromFirestore(doc));
      final list = purchases.toList();
      list.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
      return list;
    });
  }

  Stream<List<Purchase>> getPurchasesStreamForUser(String ownerId) async* {
    await _ensureInitialized();

    yield* _firestore
        .collection(_collectionName)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
          final purchases = snapshot.docs.map(
            (doc) => Purchase.fromFirestore(doc),
          );
          final list = purchases.toList();
          list.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
          return list;
        });
  }

  String _cartItemTypeToString(CartItemType type) {
    switch (type) {
      case CartItemType.food:
        return 'food';
      case CartItemType.medicine:
        return 'medicine';
      case CartItemType.toy:
        return 'toy';
      case CartItemType.cage:
        return 'cage';
    }
  }

  Future<void> addPurchasesForUser({
    required String ownerId,
    required List<CartItem> items,
    double? subtotal,
    double? tax,
    double? total,
  }) async {
    if (items.isEmpty) return;

    await _ensureInitialized();

    final now = DateTime.now();
    final checkoutId = _firestore.collection(_collectionName).doc().id;

    final batch = _firestore.batch();

    for (final item in items) {
      final docRef = _firestore.collection(_collectionName).doc();

      final purchase = Purchase(
        id: docRef.id,
        ownerId: ownerId,
        checkoutId: checkoutId,
        itemId: item.id,
        itemName: item.name,
        itemType: _cartItemTypeToString(item.type),
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
        purchasedAt: now,
      );

      final map = <String, dynamic>{
        ...purchase.toFirestoreMap(),
        'purchasedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (subtotal != null) map['orderSubtotal'] = subtotal;
      if (tax != null) map['orderTax'] = tax;
      if (total != null) map['orderTotal'] = total;

      batch.set(docRef, map);
    }

    await batch.commit();
  }
}
