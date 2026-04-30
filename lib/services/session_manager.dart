import 'package:firebase_auth/firebase_auth.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current session user
  User? get currentUser => _auth.currentUser;

  // Get user ID
  String? get userId => _auth.currentUser?.uid;

  // Get user email
  String? get userEmail => _auth.currentUser?.email;

  // Get user display name
  String? get userDisplayName => _auth.currentUser?.displayName;

  // Get user photo URL
  String? get userPhotoURL => _auth.currentUser?.photoURL;

  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Get authentication state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user state (more detailed)
  Stream<User?> get userChanges => _auth.userChanges();

  // Get session duration
  DateTime? get lastSignInTime => _auth.currentUser?.metadata.lastSignInTime;

  // Get account creation time
  DateTime? get creationTime => _auth.currentUser?.metadata.creationTime;

  // Refresh user data
  Future<void> refreshUserData() async {
    await _auth.currentUser?.reload();
  }

  // Get formatted user info
  Map<String, String?> getUserInfo() {
    return {
      'uid': userId,
      'email': userEmail,
      'displayName': userDisplayName,
      'photoURL': userPhotoURL,
      'emailVerified': isEmailVerified.toString(),
      'isAuthenticated': isAuthenticated.toString(),
    };
  }

  // Check if session is still active
  Future<bool> isSessionActive() async {
    try {
      await refreshUserData();
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  // Get session details
  Map<String, dynamic> getSessionDetails() {
    return {
      'userId': userId,
      'email': userEmail,
      'displayName': userDisplayName,
      'lastSignIn': lastSignInTime,
      'accountCreated': creationTime,
      'isActive': isAuthenticated,
    };
  }
}
