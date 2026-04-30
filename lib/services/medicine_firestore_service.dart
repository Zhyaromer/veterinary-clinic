import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/medicine.dart';

class MedicineFirestoreService {
  static final MedicineFirestoreService _instance =
      MedicineFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory MedicineFirestoreService() {
    return _instance;
  }

  MedicineFirestoreService._internal();

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Check if Firebase is initialized
        if (Firebase.apps.isEmpty) {
          throw Exception('Firebase has not been initialized. Please ensure Firebase.initializeApp() is called in main.dart');
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

  final String _collectionName = 'medicines';

  /// Get all medicines as a stream (real-time updates)
  Stream<List<Medicine>> getMedicinesStream() async* {
    await _ensureInitialized();
    yield* _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _medicineFromFirestore(doc)).toList();
    });
  }

  /// Get all medicines as a future (one-time fetch)
  Future<List<Medicine>> getAllMedicines() async {
    await _ensureInitialized();
    final snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => _medicineFromFirestore(doc)).toList();
  }

  /// Get a single medicine by ID
  Future<Medicine?> getMedicineById(String medicineId) async {
    try {
      await _ensureInitialized();
      final doc = await _firestore
          .collection(_collectionName)
          .doc(medicineId)
          .get();
      if (doc.exists) {
        return _medicineFromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching medicine: $e');
    }
    return null;
  }

  /// Search medicines by name or category
  Future<List<Medicine>> searchMedicines(String query) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore.collection(_collectionName).get();
      final medicines = snapshot.docs.map((doc) => _medicineFromFirestore(doc));

      return medicines
          .where((medicine) =>
              medicine.name.toLowerCase().contains(query.toLowerCase()) ||
              medicine.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching medicines: $e');
      return [];
    }
  }

  /// Filter medicines by category
  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => _medicineFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching medicines by category: $e');
      return [];
    }
  }

  /// Filter medicines by animal type
  Future<List<Medicine>> getMedicinesByAnimalType(String animalType) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('animalType', arrayContains: animalType)
          .get();
      return snapshot.docs.map((doc) => _medicineFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching medicines by animal type: $e');
      return [];
    }
  }

  /// Add a new medicine
  Future<String> addMedicine(Medicine medicine) async {
    try {
      await _ensureInitialized();
      final docRef =
          await _firestore.collection(_collectionName).add(_medicineToMap(medicine, isUpdate: false));
      return docRef.id;
    } catch (e) {
      print('Error adding medicine: $e');
      rethrow;
    }
  }

  /// Update an existing medicine
  Future<void> updateMedicine(String medicineId, Medicine medicine) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(medicineId)
          .update(_medicineToMap(medicine, isUpdate: true));
    } catch (e) {
      print('Error updating medicine: $e');
      rethrow;
    }
  }

  /// Delete a medicine
  Future<void> deleteMedicine(String medicineId) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(medicineId).delete();
    } catch (e) {
      print('Error deleting medicine: $e');
      rethrow;
    }
  }

  /// Update medicine stock
  Future<void> updateStock(String medicineId, int newStock) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(medicineId)
          .update({'stock': newStock});
    } catch (e) {
      print('Error updating stock: $e');
      rethrow;
    }
  }

  /// Get medicines by price range
  Future<List<Medicine>> getMedicinesByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      await _ensureInitialized();
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .get();
      return snapshot.docs.map((doc) => _medicineFromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching medicines by price range: $e');
      return [];
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

  Medicine _medicineFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return Medicine(
      id: doc.id,
      name: data['name'] as String? ?? '',
      barcode: data['barcode'] as String? ?? '',
      batchNumber: data['batchNumber'] as String? ?? '',
      composition: data['composition'] as String? ?? '',
      form: data['form'] as String? ?? '',
      route: data['route'] as String? ?? '',
      animalType: data['animalType'] as String? ?? '',
      category: data['category'] as String? ?? '',
      indications: _safeListFromFirestore(data['indications']),
      dosage: data['dosage'] as String? ?? '',
      administrationInstructions: data['administrationInstructions'] as String? ?? '',
      usage: data['usage'] as String? ?? '',
      sideEffects: _safeListFromFirestore(data['sideEffects']),
      interactions: _safeListFromFirestore(data['interactions']),
      contraindications: _safeListFromFirestore(data['contraindications']),
      overdose: data['overdose'] as String? ?? '',
      handlingPrecautions: data['handlingPrecautions'] as String? ?? '',
      storage: MedicineStorage(
        temperature: (data['storage'] as Map<String, dynamic>?)?['temperature'] as String? ?? '',
        lightProtection: (data['storage'] as Map<String, dynamic>?)?['lightProtection'] as String? ?? '',
        afterOpening: (data['storage'] as Map<String, dynamic>?)?['afterOpening'] as String? ?? '',
      ),
      withdrawalPeriod: data['withdrawalPeriod'] as String? ?? '',
      packaging: data['packaging'] as String? ?? '',
      manufacturer: Manufacturer(
        name: (data['manufacturer'] as Map<String, dynamic>?)?['name'] as String? ?? '',
        address: (data['manufacturer'] as Map<String, dynamic>?)?['address'] as String? ?? '',
        phone: (data['manufacturer'] as Map<String, dynamic>?)?['phone'] as String? ?? '',
      ),
      regulatoryApprovalNumber: data['regulatoryApprovalNumber'] as String? ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      stock: (data['stock'] as num? ?? 0).toInt(),
      expiryDate: data['expiryDate'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> _medicineToMap(Medicine medicine, {bool isUpdate = false}) {
    final map = {
      'name': medicine.name,
      'barcode': medicine.barcode,
      'batchNumber': medicine.batchNumber,
      'composition': medicine.composition,
      'form': medicine.form,
      'route': medicine.route,
      'animalType': medicine.animalType,
      'category': medicine.category,
      'indications': medicine.indications,
      'dosage': medicine.dosage,
      'administrationInstructions': medicine.administrationInstructions,
      'usage': medicine.usage,
      'sideEffects': medicine.sideEffects,
      'interactions': medicine.interactions,
      'contraindications': medicine.contraindications,
      'overdose': medicine.overdose,
      'handlingPrecautions': medicine.handlingPrecautions,
      'storage': {
        'temperature': medicine.storage.temperature,
        'lightProtection': medicine.storage.lightProtection,
        'afterOpening': medicine.storage.afterOpening,
      },
      'withdrawalPeriod': medicine.withdrawalPeriod,
      'packaging': medicine.packaging,
      'manufacturer': {
        'name': medicine.manufacturer.name,
        'address': medicine.manufacturer.address,
        'phone': medicine.manufacturer.phone,
      },
      'regulatoryApprovalNumber': medicine.regulatoryApprovalNumber,
      'price': medicine.price,
      'stock': medicine.stock,
      'expiryDate': medicine.expiryDate,
      'imageUrl': medicine.imageUrl,
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
