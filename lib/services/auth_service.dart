import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_training_app/models/user_model.dart';
import 'package:tennis_training_app/services/firebase_service.dart';
import 'package:tennis_training_app/services/user_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();
  final UserService _userService = UserService();

  // Get current user
  User? get currentUser => _firebaseService.auth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseService.auth.authStateChanges();

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? contactNumber,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user profile in Firestore
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        username: username,
        contactNumber: contactNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user to Firestore
      await _userService.createUser(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Get user data from Firestore
      UserModel user = await _userService.getUser(userCredential.user!.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseService.auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      String uid = currentUser!.uid;
      await _userService.deleteUser(uid);
      await currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _userService.updateUser(user);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}