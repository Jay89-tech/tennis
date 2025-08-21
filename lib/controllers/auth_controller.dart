import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_training_app/models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          contactNumber: contactNumber,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        return user;
      }
    } on FirebaseAuthException catch (e) {
      print("Registration Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("An unexpected error occurred");
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
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("An unexpected error occurred");
    }
    return null;
  }

  // Forgot password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Password Reset Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("An unexpected error occurred");
    }
  }

  // Check if user is logged in
  Stream<User?> get userStream => _auth.authStateChanges();
}