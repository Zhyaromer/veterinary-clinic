import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/pet_cage.dart';

class CageFirestoreService {
  static final CageFirestoreService _instance =
      CageFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory CageFirestoreService() {
    return _instance;
  }

  CageFirestoreService._internal();

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Check if Firebase is initialized
        if (Firebase.apps.isEmpty) {
          throw Exception(
            'Firebase has not been initialized. Please ensure Firebase.initializeApp() is called in main.dart',
          );
        }
        _firestore = FirebaseFirestore.instance;
        // Configure Firestore settings for better offline support
        _firestore.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        _isInitialized = true;
        print('Firestore initialized successfully');
      } catch (e) {
        print('Error initializing Firestore: $e');
        rethrow;
      }
    }
  }

  /// Diagnostic method to check Firestore connection
  Future<bool> checkConnection() async {
    try {
      await _ensureInitialized();
      // Try to read a document to verify connection
      await _firestore.collection('_health_check').doc('ping').get();
      print('Firestore connection successful');
      return true;
    } catch (e) {
      print('Firestore connection failed: $e');
      return false;
    }
  }

  final String _collectionName = 'cages';

  /// Get all cages as a stream (real-time updates)
  Stream<List<PetCage>> getCagesStream() async* {
    await _ensureInitialized();
    yield* _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
    });
  }

  /// Get all cages as a future (one-time fetch)
  Future<List<PetCage>> getAllCages() async {
    await _ensureInitialized();
    final snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
  }

  /// Get a single cage by ID
  Future<PetCage?> getCageById(String cageId) async {
    try {
      await _ensureInitialized();
      final doc = await _firestore
          .collection(_collectionName)
          .doc(cageId)
          .get();
      if (doc.exists) {
        return _cageFromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching cage: $e');
    }
    return null;
  }

  /// Search cages by name or category
  Future<List<PetCage>> searchCages(String query) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore.collection(_collectionName).get();
      final cages = snapshot.docs.map((doc) => _cageFromFirestore(doc));

      return cages
          .where(
            (cage) =>
                cage.name.toLowerCase().contains(query.toLowerCase()) ||
                cage.category.toLowerCase().contains(query.toLowerCase()) ||
                cage.brand.toLowerCase().contains(query.toLowerCase()) ||
                cage.manufacturer.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      print('Error searching cages: $e');
      return [];
    }
  }

  /// Filter cages by pet type
  Future<List<PetCage>> getCagesByPetType(String petType) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('petType', isEqualTo: petType)
          .get();
      return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cages by pet type: $e');
      return [];
    }
  }

  /// Filter cages by category
  Future<List<PetCage>> getCagesByCategory(String category) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cages by category: $e');
      return [];
    }
  }

  /// Filter cages by brand
  Future<List<PetCage>> getCagesByBrand(String brand) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('brand', isEqualTo: brand)
          .get();
      return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cages by brand: $e');
      return [];
    }
  }

  /// Get cages by price range
  Future<List<PetCage>> getCagesByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .get();
      return snapshot.docs.map((doc) => _cageFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching cages by price range: $e');
      return [];
    }
  }

  /// Add a new cage
  Future<String> addCage(PetCage cage) async {
    try {
      await _ensureInitialized();
      final docRef = await _firestore
          .collection(_collectionName)
          .add(_cageToMap(cage, isUpdate: false));
      return docRef.id;
    } catch (e) {
      print('Error adding cage: $e');
      rethrow;
    }
  }

  /// Update an existing cage
  Future<void> updateCage(String cageId, PetCage cage) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(cageId)
          .update(_cageToMap(cage, isUpdate: true));
    } catch (e) {
      print('Error updating cage: $e');
      rethrow;
    }
  }

  /// Delete a cage
  Future<void> deleteCage(String cageId) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(cageId).delete();
    } catch (e) {
      print('Error deleting cage: $e');
      rethrow;
    }
  }

  /// Update cage stock
  Future<void> updateStock(String cageId, int newStock) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(cageId).update({
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

  PetCage _cageFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return PetCage(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      petType: data['petType'] as String? ?? '',
      dimensions: data['dimensions'] as String? ?? '',
      material: data['material'] as String? ?? '',
      weight: data['weight'] as String? ?? '',
      assemblyRequired: data['assemblyRequired'] as String? ?? '',
      features: _safeListFromFirestore(data['features']),
      price: (data['price'] as num? ?? 0).toDouble(),
      stock: (data['stock'] as num? ?? 0).toInt(),
      brand: data['brand'] as String? ?? '',
      manufacturer: data['manufacturer'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      cleaningInstructions: data['cleaningInstructions'] as String? ?? '',
      warranty: data['warranty'] as String? ?? '',
      isPortable: data['isPortable'] as bool? ?? false,
      hasWheels: data['hasWheels'] as bool? ?? false,
      includedAccessories: data['includedAccessories'] as String? ?? '',
    );
  }

  Map<String, dynamic> _cageToMap(PetCage cage, {bool isUpdate = false}) {
    final map = {
      'name': cage.name,
      'description': cage.description,
      'category': cage.category,
      'petType': cage.petType,
      'dimensions': cage.dimensions,
      'material': cage.material,
      'weight': cage.weight,
      'assemblyRequired': cage.assemblyRequired,
      'features': cage.features,
      'price': cage.price,
      'stock': cage.stock,
      'brand': cage.brand,
      'manufacturer': cage.manufacturer,
      'imageUrl': cage.imageUrl,
      'cleaningInstructions': cage.cleaningInstructions,
      'warranty': cage.warranty,
      'isPortable': cage.isPortable,
      'hasWheels': cage.hasWheels,
      'includedAccessories': cage.includedAccessories,
    };

    // Only set createdAt for new documents
    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }

    // Always update updatedAt
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}