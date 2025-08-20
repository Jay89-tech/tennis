// File: lib/controllers/auth_controller.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthController() {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(_user!.uid)
            .get();
        
        if (doc.exists) {
          _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          notifyListeners();
        }
      } catch (e) {
        _setError('Failed to load user data: ${e.toString()}');
      }
    }
  }

  // Register new user
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? contactNumber,
  }) async {
    try {
      _setLoading(true);
      clearError();

      // Check if username already exists
      QuerySnapshot usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        _setError('Username already exists');
        return false;
      }

      // Create user with Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Create user model
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          contactNumber: contactNumber,
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());

        _userModel = newUser;
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      clearError();

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword({required String email}) async {
    try {
      _setLoading(true);
      clearError();

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _userModel = null;
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    }
  }

  // Get user-friendly error messages
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}