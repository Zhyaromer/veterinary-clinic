# Firestore Setup Guide for Vet Clinic Medicine Module

## Prerequisites
1. Firebase Project created and configured
2. Firestore database enabled
3. Google Services JSON configured for Android
4. Firebase options file generated

## Firestore Collections

### Medicines Collection
Collection name: `medicines`

**Document fields:**
```
- name: String
- barcode: String
- batchNumber: String
- composition: String
- form: String
- route: String
- animalType: String
- category: String
- indications: Array<String>
- dosage: String
- administrationInstructions: String
- usage: String
- sideEffects: Array<String>
- interactions: Array<String>
- contraindications: Array<String>
- overdose: String
- handlingPrecautions: String
- storage: Object
  - temperature: String
  - lightProtection: String
  - afterOpening: String
- withdrawalPeriod: String
- packaging: String
- manufacturer: Object
  - name: String
  - address: String
  - phone: String
- regulatoryApprovalNumber: String
- price: Number (double)
- stock: Number (int)
- expiryDate: String
- imageUrl: String
- createdAt: Timestamp
- updatedAt: Timestamp
```

## Firestore Security Rules

Replace the default rules in your Firebase Console with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read all medicines
    match /medicines/{document=**} {
      allow read: if request.auth.uid != null;
      allow create, update, delete: if request.auth.uid != null;
    }
    
    // Optional: Health check for connection verification
    match /_health_check/{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Troubleshooting

### "Unable to establish a connection on channel to Firestore"
1. Verify Firestore is enabled in Firebase Console
2. Check Firebase project configuration in `firebase_options.dart`
3. Verify internet connectivity
4. Check Firestore security rules are not blocking access
5. Ensure `cloud_firestore` package is properly installed: `flutter pub get`

### App loads but Firestore is empty
1. The app is working correctly - Firestore is just empty
2. Add medicines through the Medicine Management page
3. Data will persist in Firestore

### Data not persisting
1. Check Firestore security rules
2. Verify Firestore database is created in Firebase Console
3. Check for errors in the debug console
4. Verify the document ID is being generated correctly

## Service Usage

```dart
final medicineService = MedicineFirestoreService();

// Get all medicines
List<Medicine> medicines = await medicineService.getAllMedicines();

// Add a new medicine
String docId = await medicineService.addMedicine(medicine);

// Update a medicine
await medicineService.updateMedicine(docId, updatedMedicine);

// Delete a medicine
await medicineService.deleteMedicine(docId);

// Update stock only
await medicineService.updateStock(docId, newStock);

// Search medicines
List<Medicine> results = await medicineService.searchMedicines('Amoxicillin');

// Get medicines by category
List<Medicine> antibiotics = await medicineService.getMedicinesByCategory('Antibiotic');

// Check connection
bool connected = await medicineService.checkConnection();
```

## Firestore Pricing
- Free tier: 50,000 reads, 20,000 writes, 20,000 deletes per day
- For production, consider Firestore billing

## Next Steps
1. Ensure Firestore is properly configured in Firebase Console
2. Update security rules with the provided rules
3. Run the app and test adding medicines
4. Check browser console and Flutter debug logs for any errors
