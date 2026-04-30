import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vet_clinic/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;
  bool _isEmailVerified = false;
  bool _isCheckingVerification = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get initialized => _initialized;
  bool get isEmailVerified => _isEmailVerified;
  bool get isCheckingVerification => _isCheckingVerification;

  // Check if user is authenticated AND email is verified
  bool get canAccessApp => isAuthenticated && isEmailVerified;

  AuthProvider() {
    _initializeAuthListener();
  }

  // Initialize auth state listener
  void _initializeAuthListener() {
    try {
      _authService.authStateChanges.listen(
        (User? user) {
          _user = user;
          _isEmailVerified = user?.emailVerified ?? false;
          _initialized = true;
          notifyListeners();
        },
        onError: (error) {
          print('Auth state change error: $error');
          _initialized = true;
          _user = null;
          _isEmailVerified = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print('Error initializing auth listener: $e');
      _initialized = true;
      notifyListeners();
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      _isLoading = false;
      _isEmailVerified = false; // New user hasn't verified yet
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      // Check verification status after login
      await refreshEmailVerificationStatus();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _isEmailVerified = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh email verification status
  Future<void> refreshEmailVerificationStatus() async {
    _isCheckingVerification = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _isEmailVerified = await _authService.refreshEmailVerificationStatus();
      _isCheckingVerification = false;
      notifyListeners();
    } catch (e) {
      print('Error checking email verification: $e');
      _errorMessage = _getErrorMessage(e);
      _isCheckingVerification = false;
      notifyListeners();
    }
  }

  // Resend verification email
  Future<bool> resendVerificationEmail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resendVerificationEmail();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getFirebaseAuthErrorMessage(error.code);
    }
    return 'An error occurred. Please try again.';
  }

  // Get Firebase specific error message
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Operation is not allowed.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found. Please login again.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'verification-check-failed':
        return 'Failed to check verification status. Make sure you clicked the link in the email, then try again.';
      case 'email-not-verified':
        return 'Email not verified yet. Please check your email and click the verification link.';
      default:
        return 'An error occurred. Please try again or contact support.';
    }
  }
}
