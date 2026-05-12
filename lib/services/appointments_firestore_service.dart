import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/appointment.dart';

class AppointmentsFirestoreService {
  static final AppointmentsFirestoreService _instance =
      AppointmentsFirestoreService._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory AppointmentsFirestoreService() {
    return _instance;
  }

  AppointmentsFirestoreService._internal();

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
    // ignore: avoid_print
    print('Appointments Firestore initialized successfully');
  }

  final String _collectionName = 'appointments';

  Stream<List<Appointment>> getAppointmentsStreamForUser(
    String ownerId,
  ) async* {
    await _ensureInitialized();
    yield* _firestore
        .collection(_collectionName)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs.map((doc) => _fromDoc(doc)).toList();
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        });
  }

  Stream<List<Appointment>> getAppointmentsStream() async* {
    await _ensureInitialized();
    yield* _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => _fromDoc(doc)).toList();
        });
  }

  Future<List<Appointment>> getAllAppointments() async {
    await _ensureInitialized();
    final snapshot = await _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => _fromDoc(doc)).toList();
  }

  Future<String> addAppointment(Appointment appointment) async {
    await _ensureInitialized();
    final docRef = await _firestore
        .collection(_collectionName)
        .add(_toMap(appointment, isUpdate: false));
    return docRef.id;
  }

  Future<String> addAppointmentForUser({
    required String ownerId,
    required Appointment appointment,
  }) async {
    await _ensureInitialized();
    final docRef = await _firestore
        .collection(_collectionName)
        .add(_toMap(appointment, isUpdate: false, ownerId: ownerId));
    return docRef.id;
  }

  Future<void> updateAppointment(
    String appointmentId,
    Appointment appointment,
  ) async {
    await _ensureInitialized();
    await _firestore
        .collection(_collectionName)
        .doc(appointmentId)
        .update(_toMap(appointment, isUpdate: true));
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _ensureInitialized();
    await _firestore.collection(_collectionName).doc(appointmentId).delete();
  }

  Appointment _fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    final Timestamp? appointmentDateTs = data['appointmentDate'] as Timestamp?;
    final appointmentDate = appointmentDateTs?.toDate() ?? DateTime.now();

    final hour = (data['appointmentTimeHour'] as num? ?? 0).toInt();
    final minute = (data['appointmentTimeMinute'] as num? ?? 0).toInt();

    final Timestamp? createdAtTs = data['createdAt'] as Timestamp?;
    final createdAt =
        createdAtTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);

    return Appointment(
      id: doc.id,
      petName: data['petName'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      email: data['email'] as String? ?? '',
      petType: data['petType'] as String? ?? '',
      petBreed: data['petBreed'] as String? ?? '',
      petAge: data['petAge'] as String? ?? '',
      appointmentDate: appointmentDate,
      appointmentTime: TimeOfDay(hour: hour, minute: minute),
      reason: data['reason'] as String? ?? '',
      symptoms: data['symptoms'] as String? ?? '',
      emergency: data['emergency'] as bool? ?? false,
      vetPreference: data['vetPreference'] as String? ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> _toMap(
    Appointment appointment, {
    required bool isUpdate,
    String? ownerId,
  }) {
    final map = <String, dynamic>{
      if (ownerId != null) 'ownerId': ownerId,
      'petName': appointment.petName,
      'ownerName': appointment.ownerName,
      'phoneNumber': appointment.phoneNumber,
      'email': appointment.email,
      'petType': appointment.petType,
      'petBreed': appointment.petBreed,
      'petAge': appointment.petAge,
      'appointmentDate': Timestamp.fromDate(
        DateTime(
          appointment.appointmentDate.year,
          appointment.appointmentDate.month,
          appointment.appointmentDate.day,
        ),
      ),
      'appointmentTimeHour': appointment.appointmentTime.hour,
      'appointmentTimeMinute': appointment.appointmentTime.minute,
      'reason': appointment.reason,
      'symptoms': appointment.symptoms,
      'emergency': appointment.emergency,
      'vetPreference': appointment.vetPreference,
    };

    if (!isUpdate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();

    return map;
  }
}
