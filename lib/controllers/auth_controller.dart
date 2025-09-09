import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_training_app/models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if username is available using dedicated usernames collection
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final usernameDoc = await _firestore
          .collection('usernames')
          .doc(username.toLowerCase())
          .get();
      
      return !usernameDoc.exists;
    } catch (e) {
      print("Username availability check error: $e");
      throw Exception("Failed to check username availability: $e");
    }
  }

  // Check if email is already registered (we'll remove this since Firebase Auth handles it)
  // No need for email availability check - Firebase Auth will handle duplicate emails

  // Register user
  Future<UserModel?> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? contactNumber,
  }) async {
    try {
      // Check if username is available
      bool usernameAvailable = await isUsernameAvailable(username);
      if (!usernameAvailable) {
        throw Exception("Username is already taken");
      }

      // Create Firebase Auth user first
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          username: username.toLowerCase(), // Store username in lowercase
          email: email.toLowerCase(), // Store email in lowercase
          contactNumber: contactNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Use batch write to ensure both operations succeed or fail together
        WriteBatch batch = _firestore.batch();
        
        // Create user document in Firestore
        batch.set(
          _firestore.collection('users').doc(userCredential.user!.uid),
          user.toMap()
        );
        
        // Reserve the username in usernames collection
        batch.set(
          _firestore.collection('usernames').doc(username.toLowerCase()),
          {
            'uid': userCredential.user!.uid,
            'reserved_at': FieldValue.serverTimestamp(),
          }
        );

        // Commit both operations
        await batch.commit();

        print("User registered successfully: ${user.username}");
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      
      // Handle specific Firebase errors
      switch (e.code) {
        case 'weak-password':
          throw Exception("Password is too weak");
        case 'email-already-in-use':
          throw Exception("Email is already registered");
        case 'invalid-email':
          throw Exception("Invalid email address");
        case 'operation-not-allowed':
          throw Exception("Email/password accounts are not enabled");
        default:
          throw Exception(e.message ?? "Registration failed");
      }
    } catch (e) {
      print("Registration error: $e");
      throw Exception("Registration failed: $e");
    }
    return null;
  }

  // Login user
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          throw Exception("User data not found");
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      
      switch (e.code) {
        case 'user-not-found':
          throw Exception("No user found with this email");
        case 'wrong-password':
          throw Exception("Incorrect password");
        case 'invalid-email':
          throw Exception("Invalid email address");
        case 'user-disabled':
          throw Exception("User account has been disabled");
        case 'too-many-requests':
          throw Exception("Too many failed attempts. Try again later");
        default:
          throw Exception(e.message ?? "Login failed");
      }
    } catch (e) {
      print("Login error: $e");
      throw Exception("Login failed: $e");
    }
    return null;
  }

  // Forgot password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.toLowerCase());
    } on FirebaseAuthException catch (e) {
      print("Password Reset Error: ${e.message}");
      
      switch (e.code) {
        case 'user-not-found':
          throw Exception("No user found with this email");
        case 'invalid-email':
          throw Exception("Invalid email address");
        default:
          throw Exception(e.message ?? "Password reset failed");
      }
    } catch (e) {
      print("Password reset error: $e");
      throw Exception("Password reset failed: $e");
    }
  }

  // Check if user is logged in
  Stream<User?> get userStream => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Sign out error: $e");
      throw Exception("Sign out failed");
    }
  }
}