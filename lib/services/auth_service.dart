import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get user state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Check if email is verified
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  // Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with display name
      await userCredential.user?.updateDisplayName(displayName);

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Password reset
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() => _firebaseAuth.currentUser != null;

  // Get current user email
  String? getCurrentUserEmail() => _firebaseAuth.currentUser?.email;

  // Get current user display name
  String? getCurrentUserDisplayName() => _firebaseAuth.currentUser?.displayName;

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
        await user.reload();
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Refresh email verification status
  Future<bool> refreshEmailVerificationStatus() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found. Please login again.',
        );
      }
      
      // Reload user data from Firebase
      await user.reload();
      
      // Get fresh user instance
      user = _firebaseAuth.currentUser;
      return user?.emailVerified ?? false;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      print('Error refreshing email verification: $e');
      throw FirebaseAuthException(
        code: 'verification-check-failed',
        message: 'Failed to check email verification status. Please try again.',
      );
    }
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
