import 'package:flutter/material.dart';
import 'package:vet_clinic/services/medicine_firestore_service.dart';

/// Firestore Connection Debug Widget
/// Add this to your app temporarily to test Firestore connectivity
class FirestoreDebugWidget extends StatefulWidget {
  const FirestoreDebugWidget({Key? key}) : super(key: key);

  @override
  State<FirestoreDebugWidget> createState() => _FirestoreDebugWidgetState();
}

class _FirestoreDebugWidgetState extends State<FirestoreDebugWidget> {
  final MedicineFirestoreService _medicineService = MedicineFirestoreService();
  bool? _connectionStatus;
  String _debugMessage = 'Testing Firestore connection...';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  void _testConnection() async {
    try {
      setState(() {
        _debugMessage = 'Testing Firestore connection...';
        _connectionStatus = null;
      });

      final isConnected = await _medicineService.checkConnection();
      
      if (mounted) {
        setState(() {
          _connectionStatus = isConnected;
          _debugMessage = isConnected
              ? 'Firestore connection successful! ✅'
              : 'Firestore connection failed ❌';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _connectionStatus = false;
          _debugMessage = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Debug'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _connectionStatus == null
                    ? Colors.grey[200]
                    : _connectionStatus!
                        ? Colors.green[100]
                        : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _connectionStatus == null
                      ? Colors.grey
                      : _connectionStatus!
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _debugMessage,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _connectionStatus == null
                          ? Colors.black54
                          : _connectionStatus!
                              ? Colors.green[900]
                              : Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _testConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Troubleshooting Steps:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTroubleshootingStep(
              '1. Firestore Database',
              'Create a Firestore Database in Firebase Console',
            ),
            _buildTroubleshootingStep(
              '2. Security Rules',
              'Update Firestore security rules to allow authenticated access',
            ),
            _buildTroubleshootingStep(
              '3. Firebase Config',
              'Verify firebase_options.dart has correct configuration',
            ),
            _buildTroubleshootingStep(
              '4. Internet',
              'Check your device has internet connectivity',
            ),
            _buildTroubleshootingStep(
              '5. Dependencies',
              'Run: flutter pub get && flutter clean && flutter run',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
