import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/shelter_pet.dart';
import '../models/adoption_request.dart';

class AdoptionFirestoreService {
  static final AdoptionFirestoreService _instance =
      AdoptionFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory AdoptionFirestoreService() {
    return _instance;
  }

  AdoptionFirestoreService._internal();

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        if (Firebase.apps.isEmpty) {
          throw Exception(
              'Firebase has not been initialized. Please ensure Firebase.initializeApp() is called in main.dart');
        }
        _firestore = FirebaseFirestore.instance;
        _firestore.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        _isInitialized = true;
        print('Firestore initialized successfully for adoption service');
      } catch (e) {
        print('Error initializing Firestore: $e');
        rethrow;
      }
    }
  }

  // Shelter Pets Collection Methods
  final String _shelterPetsCollection = 'shelterPets';

  /// Get all available shelter pets
  Future<List<ShelterPet>> getAllShelterPets() async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_shelterPetsCollection)
          .where('isAdopted', isEqualTo: false)
          .get();
      return snapshot.docs
          .map((doc) => _shelterPetFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching shelter pets: $e');
      return [];
    }
  }

  /// Get a single shelter pet by ID
  Future<ShelterPet?> getShelterPetById(String petId) async {
    await _ensureInitialized();
    try {
      final doc = await _firestore
          .collection(_shelterPetsCollection)
          .doc(petId)
          .get();
      if (doc.exists) {
        return _shelterPetFromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching shelter pet: $e');
    }
    return null;
  }

  /// Search shelter pets by name or breed
  Future<List<ShelterPet>> searchShelterPets(String query) async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_shelterPetsCollection)
          .where('isAdopted', isEqualTo: false)
          .get();
      final pets = snapshot.docs.map((doc) => _shelterPetFromFirestore(doc));
      return pets
          .where((pet) =>
              pet.name.toLowerCase().contains(query.toLowerCase()) ||
              pet.breed.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching shelter pets: $e');
      return [];
    }
  }

  /// Filter shelter pets by type
  Future<List<ShelterPet>> getShelterPetsByType(String type) async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_shelterPetsCollection)
          .where('type', isEqualTo: type)
          .where('isAdopted', isEqualTo: false)
          .get();
      return snapshot.docs
          .map((doc) => _shelterPetFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching pets by type: $e');
      return [];
    }
  }

  /// Add a new shelter pet
  Future<String> addShelterPet(ShelterPet pet) async {
    await _ensureInitialized();
    try {
      final docRef = await _firestore
          .collection(_shelterPetsCollection)
          .add(_shelterPetToMap(pet, isUpdate: false));
      return docRef.id;
    } catch (e) {
      print('Error adding shelter pet: $e');
      rethrow;
    }
  }

  /// Update shelter pet
  Future<void> updateShelterPet(String petId, ShelterPet pet) async {
    await _ensureInitialized();
    try {
      await _firestore
          .collection(_shelterPetsCollection)
          .doc(petId)
          .update(_shelterPetToMap(pet, isUpdate: true));
    } catch (e) {
      print('Error updating shelter pet: $e');
      rethrow;
    }
  }

  /// Mark pet as adopted
  Future<void> markPetAsAdopted(String petId) async {
    await _ensureInitialized();
    try {
      await _firestore
          .collection(_shelterPetsCollection)
          .doc(petId)
          .update({'isAdopted': true, 'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error marking pet as adopted: $e');
      rethrow;
    }
  }

  /// Delete shelter pet
  Future<void> deleteShelterPet(String petId) async {
    await _ensureInitialized();
    try {
      await _firestore.collection(_shelterPetsCollection).doc(petId).delete();
    } catch (e) {
      print('Error deleting shelter pet: $e');
      rethrow;
    }
  }

  // Adoption Requests Collection Methods
  final String _adoptionRequestsCollection = 'adoptionRequests';

  /// Submit adoption request
  Future<String> submitAdoptionRequest(AdoptionRequest request) async {
    await _ensureInitialized();
    try {
      final docRef = await _firestore
          .collection(_adoptionRequestsCollection)
          .add(_adoptionRequestToMap(request, isUpdate: false));
      return docRef.id;
    } catch (e) {
      print('Error submitting adoption request: $e');
      rethrow;
    }
  }

  /// Get all adoption requests
  Future<List<AdoptionRequest>> getAllAdoptionRequests() async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_adoptionRequestsCollection)
          .orderBy('submittedDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => _adoptionRequestFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching adoption requests: $e');
      return [];
    }
  }

  /// Get adoption requests by status
  Future<List<AdoptionRequest>> getAdoptionRequestsByStatus(
      String status) async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_adoptionRequestsCollection)
          .where('status', isEqualTo: status)
          .orderBy('submittedDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => _adoptionRequestFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching adoption requests by status: $e');
      return [];
    }
  }

  /// Update adoption request status
  Future<void> updateAdoptionRequestStatus(
      String requestId, String newStatus,
      {String? notes}) async {
    await _ensureInitialized();
    try {
      final update = {
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (notes != null) {
        update['notes'] = notes;
      }
      await _firestore
          .collection(_adoptionRequestsCollection)
          .doc(requestId)
          .update(update);
    } catch (e) {
      print('Error updating adoption request status: $e');
      rethrow;
    }
  }

  /// Get adoption requests for a specific pet
  Future<List<AdoptionRequest>> getRequestsForPet(String petId) async {
    await _ensureInitialized();
    try {
      final snapshot = await _firestore
          .collection(_adoptionRequestsCollection)
          .where('shelterPetId', isEqualTo: petId)
          .get();
      return snapshot.docs
          .map((doc) => _adoptionRequestFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching requests for pet: $e');
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

  bool _safeBoolFromFirestore(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return false;
  }

  int _safeIntFromFirestore(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  double _safeDoubleFromFirestore(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  ShelterPet _shelterPetFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data is null');

    return ShelterPet(
      id: doc.id,
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? '',
      breed: data['breed'] as String? ?? '',
      age: data['age'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      size: data['size'] as String? ?? '',
      color: data['color'] as String? ?? '',
      location: data['location'] as String? ?? '',
      arrivalDate: data['arrivalDate'] is Timestamp
          ? (data['arrivalDate'] as Timestamp).toDate()
          : DateTime.now(),
      healthStatus: data['healthStatus'] as String? ?? '',
      isVaccinated: _safeBoolFromFirestore(data['isVaccinated']),
      isNeutered: _safeBoolFromFirestore(data['isNeutered']),
      personality: data['personality'] as String? ?? '',
      specialNeeds: _safeListFromFirestore(data['specialNeeds']),
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      isAdopted: _safeBoolFromFirestore(data['isAdopted']),
      adoptionFee: _safeDoubleFromFirestore(data['adoptionFee']),
      careLevel: _safeIntFromFirestore(data['careLevel']),
      activityLevel: _safeIntFromFirestore(data['activityLevel']),
      isGoodWithKids: _safeBoolFromFirestore(data['isGoodWithKids']),
      isGoodWithPets: _safeBoolFromFirestore(data['isGoodWithPets']),
      requirements: _safeListFromFirestore(data['requirements']),
    );
  }

  Map<String, dynamic> _shelterPetToMap(ShelterPet pet,
      {bool isUpdate = false}) {
    final map = {
      'name': pet.name,
      'type': pet.type,
      'breed': pet.breed,
      'age': pet.age,
      'gender': pet.gender,
      'size': pet.size,
      'color': pet.color,
      'location': pet.location,
      'arrivalDate': Timestamp.fromDate(pet.arrivalDate),
      'healthStatus': pet.healthStatus,
      'isVaccinated': pet.isVaccinated,
      'isNeutered': pet.isNeutered,
      'personality': pet.personality,
      'specialNeeds': pet.specialNeeds,
      'description': pet.description,
      'imageUrl': pet.imageUrl,
      'isAdopted': pet.isAdopted,
      'adoptionFee': pet.adoptionFee,
      'careLevel': pet.careLevel,
      'activityLevel': pet.activityLevel,
      'isGoodWithKids': pet.isGoodWithKids,
      'isGoodWithPets': pet.isGoodWithPets,
      'requirements': pet.requirements,
    };

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }

  AdoptionRequest _adoptionRequestFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data is null');

    return AdoptionRequest(
      id: doc.id,
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      petType: data['petType'] as String? ?? '',
      petName: data['petName'] as String? ?? '',
      breed: data['breed'] as String? ?? '',
      age: data['age'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      reason: data['reason'] as String? ?? '',
      specialNeeds: data['specialNeeds'] as String? ?? '',
      isVaccinated: _safeBoolFromFirestore(data['isVaccinated']),
      isNeutered: _safeBoolFromFirestore(data['isNeutered']),
      hasMedicalIssues: _safeBoolFromFirestore(data['hasMedicalIssues']),
      isHouseTrained: _safeBoolFromFirestore(data['isHouseTrained']),
      agreeToTerms: _safeBoolFromFirestore(data['agreeToTerms']),
      homeVisitAgreed: _safeBoolFromFirestore(data['homeVisitAgreed']),
      canAffordCare: _safeBoolFromFirestore(data['canAffordCare']),
      hasExperience: _safeBoolFromFirestore(data['hasExperience']),
      submittedDate: data['submittedDate'] is Timestamp
          ? (data['submittedDate'] as Timestamp).toDate()
          : DateTime.now(),
      status: data['status'] as String? ?? 'pending',
      shelterPetId: data['shelterPetId'] as String?,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> _adoptionRequestToMap(AdoptionRequest request,
      {bool isUpdate = false}) {
    final map = {
      'firstName': request.firstName,
      'lastName': request.lastName,
      'email': request.email,
      'phone': request.phone,
      'address': request.address,
      'petType': request.petType,
      'petName': request.petName,
      'breed': request.breed,
      'age': request.age,
      'gender': request.gender,
      'reason': request.reason,
      'specialNeeds': request.specialNeeds,
      'isVaccinated': request.isVaccinated,
      'isNeutered': request.isNeutered,
      'hasMedicalIssues': request.hasMedicalIssues,
      'isHouseTrained': request.isHouseTrained,
      'agreeToTerms': request.agreeToTerms,
      'homeVisitAgreed': request.homeVisitAgreed,
      'canAffordCare': request.canAffordCare,
      'hasExperience': request.hasExperience,
      'submittedDate': Timestamp.fromDate(request.submittedDate),
      'status': request.status,
      'shelterPetId': request.shelterPetId,
      'notes': request.notes,
    };

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}
