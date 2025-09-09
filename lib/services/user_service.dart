import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_training_app/models/user_model.dart';
import 'package:tennis_training_app/services/firebase_service.dart';

class UserService {
  final FirebaseService _firebaseService = FirebaseService();

  // Collection reference
  CollectionReference<UserModel> get usersCollection =>
      _firebaseService.firestore
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
            toFirestore: (user, _) => user.toMap(),
          );

  // Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await usersCollection.doc(user.uid).set(user);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot<UserModel> snapshot =
          await usersCollection.doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try {
      user.updatedAt = DateTime.now();
      await usersCollection.doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      QuerySnapshot<UserModel> snapshot = await usersCollection
          .where('username', isEqualTo: username.toLowerCase())
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  // Get user by username
  Future<UserModel> getUserByUsername(String username) async {
    try {
      QuerySnapshot<UserModel> snapshot = await usersCollection
          .where('username', isEqualTo: username.toLowerCase())
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to get user by username: $e');
    }
  }

  // Stream user data
  Stream<UserModel> getUserStream(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception('User not found');
      }
    });
  }
}