// services/food_firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/pet_food.dart';

class FoodFirestoreService {
  static final FoodFirestoreService _instance =
      FoodFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory FoodFirestoreService() {
    return _instance;
  }

  FoodFirestoreService._internal();

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        if (Firebase.apps.isEmpty) {
          throw Exception('Firebase has not been initialized');
        }
        _firestore = FirebaseFirestore.instance;
        _firestore.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        _isInitialized = true;
        print('Food Firestore initialized successfully');
      } catch (e) {
        print('Error initializing Food Firestore: $e');
        rethrow;
      }
    }
  }

  final String _collectionName = 'foods';

  /// Get all foods as a stream (real-time updates)
  Stream<List<PetFood>> getFoodsStream() async* {
    await _ensureInitialized();
    yield* _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _foodFromFirestore(doc)).toList();
    });
  }

  /// Get all foods as a future (one-time fetch)
  Future<List<PetFood>> getAllFoods() async {
    await _ensureInitialized();
    final snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => _foodFromFirestore(doc)).toList();
  }

  /// Add a new food
  Future<String> addFood(PetFood food) async {
    try {
      await _ensureInitialized();
      final docRef = await _firestore
          .collection(_collectionName)
          .add(_foodToMap(food, isUpdate: false));
      return docRef.id;
    } catch (e) {
      print('Error adding food: $e');
      rethrow;
    }
  }

  /// Update an existing food
  Future<void> updateFood(String foodId, PetFood food) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(foodId)
          .update(_foodToMap(food, isUpdate: true));
    } catch (e) {
      print('Error updating food: $e');
      rethrow;
    }
  }

  /// Delete a food
  Future<void> deleteFood(String foodId) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(foodId).delete();
    } catch (e) {
      print('Error deleting food: $e');
      rethrow;
    }
  }

  /// Update food stock
  Future<void> updateStock(String foodId, int newStock) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(foodId).update({
        'stock': newStock,
      });
    } catch (e) {
      print('Error updating stock: $e');
      rethrow;
    }
  }

  // Helper methods
  List<String> _safeListFromFirestore(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }

  PetFood _foodFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return PetFood(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      petType: data['petType'] as String? ?? '',
      lifeStage: data['lifeStage'] as String? ?? '',
      flavor: data['flavor'] as String? ?? '',
      primaryProtein: data['primaryProtein'] as String? ?? '',
      ingredients: _safeListFromFirestore(data['ingredients']),
      keyNutrients: _safeListFromFirestore(data['keyNutrients']),
      size: data['size'] as String? ?? '',
      weight: (data['weight'] as num? ?? 0).toDouble(),
      price: (data['price'] as num? ?? 0).toDouble(),
      stock: (data['stock'] as num? ?? 0).toInt(),
      brand: data['brand'] as String? ?? '',
      manufacturer: data['manufacturer'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      feedingGuidelines: data['feedingGuidelines'] as String? ?? '',
      storageInstructions: data['storageInstructions'] as String? ?? '',
      expiryDate: data['expiryDate'] as String? ?? '',
      isGrainFree: data['isGrainFree'] as bool? ?? false,
      isOrganic: data['isOrganic'] as bool? ?? false,
      isPrescriptionRequired: data['isPrescriptionRequired'] as bool? ?? false,
      nutritionalGuarantee: data['nutritionalGuarantee'] as String? ?? '',
    );
  }

  Map<String, dynamic> _foodToMap(PetFood food, {bool isUpdate = false}) {
    final map = {
      'name': food.name,
      'description': food.description,
      'category': food.category,
      'petType': food.petType,
      'lifeStage': food.lifeStage,
      'flavor': food.flavor,
      'primaryProtein': food.primaryProtein,
      'ingredients': food.ingredients,
      'keyNutrients': food.keyNutrients,
      'size': food.size,
      'weight': food.weight,
      'price': food.price,
      'stock': food.stock,
      'brand': food.brand,
      'manufacturer': food.manufacturer,
      'imageUrl': food.imageUrl,
      'feedingGuidelines': food.feedingGuidelines,
      'storageInstructions': food.storageInstructions,
      'expiryDate': food.expiryDate,
      'isGrainFree': food.isGrainFree,
      'isOrganic': food.isOrganic,
      'isPrescriptionRequired': food.isPrescriptionRequired,
      'nutritionalGuarantee': food.nutritionalGuarantee,
    };

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}
