import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/my_pet.dart';

class MyPetsFirestoreService {
  static final MyPetsFirestoreService _instance =
      MyPetsFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory MyPetsFirestoreService() {
    return _instance;
  }

  MyPetsFirestoreService._internal();

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
      print('MyPets Firestore initialized successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error initializing MyPets Firestore: $e');
      rethrow;
    }
  }

  final String _collectionName = 'mypets';

  Stream<List<MyPet>> getPetsStream() async* {
    await _ensureInitialized();
    yield* _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
        });
  }

  Future<List<MyPet>> getAllPets() async {
    await _ensureInitialized();
    final snapshot = await _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
  }

  Future<String> addPet(MyPet pet) async {
    try {
      await _ensureInitialized();
      final docRef = await _firestore
          .collection(_collectionName)
          .add(_petToMap(pet, isUpdate: false));
      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('Error adding pet: $e');
      rethrow;
    }
  }

  Future<void> updatePet(String petId, MyPet pet) async {
    try {
      await _ensureInitialized();
      await _firestore
          .collection(_collectionName)
          .doc(petId)
          .update(_petToMap(pet, isUpdate: true));
    } catch (e) {
      // ignore: avoid_print
      print('Error updating pet: $e');
      rethrow;
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _ensureInitialized();
      await _firestore.collection(_collectionName).doc(petId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting pet: $e');
      rethrow;
    }
  }

  MyPet _petFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return MyPet(
      id: doc.id,
      name: data['name'] as String? ?? '',
      age: (data['age'] as num? ?? 0).toInt(),
      type: data['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> _petToMap(MyPet pet, {required bool isUpdate}) {
    final map = {'name': pet.name, 'age': pet.age, 'type': pet.type};

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}
