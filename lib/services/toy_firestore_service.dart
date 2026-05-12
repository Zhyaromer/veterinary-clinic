import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/pet_toy.dart';

class ToyFirestoreService {
  static final ToyFirestoreService _instance = ToyFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory ToyFirestoreService() {
    return _instance;
  }

  ToyFirestoreService._internal();

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

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
      // ignore: avoid_print
      print('Toy Firestore initialized successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error initializing Toy Firestore: $e');
      rethrow;
    }
  }

  final String _collectionName = 'toys';

  Stream<List<PetToy>> getToysStream() async* {
    await _ensureInitialized();
    yield* _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _toyFromFirestore(doc)).toList();
    });
  }

  Future<List<PetToy>> getAllToys() async {
    await _ensureInitialized();
    final snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => _toyFromFirestore(doc)).toList();
  }

  Future<String> addToy(PetToy toy) async {
    try {
      await _ensureInitialized();
      final docRef = await _firestore
          .collection(_collectionName)
          .add(_toyToMap(toy, isUpdate: false));
      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('Error adding toy: $e');
      rethrow;
    }
  }

  Future<void> updateToy(String toyId, PetToy toy) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(toyId)
          .update(_toyToMap(toy, isUpdate: true));
    } catch (e) {
      // ignore: avoid_print
      print('Error updating toy: $e');
      rethrow;
    }
  }

  Future<void> deleteToy(String toyId) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(toyId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting toy: $e');
      rethrow;
    }
  }

  Future<void> updateStock(String toyId, int newStock) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(toyId).update({
        'stock': newStock,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error updating toy stock: $e');
      rethrow;
    }
  }

  List<String> _safeListFromFirestore(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }

  PetToy _toyFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return PetToy(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      petType: data['petType'] as String? ?? '',
      size: data['size'] as String? ?? '',
      material: data['material'] as String? ?? '',
      safetyFeatures: data['safetyFeatures'] as String? ?? '',
      features: _safeListFromFirestore(data['features']),
      price: (data['price'] as num? ?? 0).toDouble(),
      stock: (data['stock'] as num? ?? 0).toInt(),
      brand: data['brand'] as String? ?? '',
      manufacturer: data['manufacturer'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      cleaningInstructions: data['cleaningInstructions'] as String? ?? '',
      warranty: data['warranty'] as String? ?? '',
      isInteractive: data['isInteractive'] as bool? ?? false,
      isChewResistant: data['isChewResistant'] as bool? ?? false,
      ageSuitability: data['ageSuitability'] as String? ?? '',
    );
  }

  Map<String, dynamic> _toyToMap(PetToy toy, {required bool isUpdate}) {
    final map = {
      'name': toy.name,
      'description': toy.description,
      'category': toy.category,
      'petType': toy.petType,
      'size': toy.size,
      'material': toy.material,
      'safetyFeatures': toy.safetyFeatures,
      'features': toy.features,
      'price': toy.price,
      'stock': toy.stock,
      'brand': toy.brand,
      'manufacturer': toy.manufacturer,
      'imageUrl': toy.imageUrl,
      'cleaningInstructions': toy.cleaningInstructions,
      'warranty': toy.warranty,
      'isInteractive': toy.isInteractive,
      'isChewResistant': toy.isChewResistant,
      'ageSuitability': toy.ageSuitability,
    };

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}
