import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tennis_training_app/services/firebase_service.dart';

class StorageService {
  final FirebaseService _firebaseService = FirebaseService();

  // Reference to user profile pictures
  Reference get userProfilePicturesRef =>
      _firebaseService.storage.ref().child('profile_pictures');

  // Upload profile picture
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      Reference ref = userProfilePicturesRef.child('$userId.jpg');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // Delete profile picture
  Future<void> deleteProfilePicture(String userId) async {
    try {
      Reference ref = userProfilePicturesRef.child('$userId.jpg');
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  // Get profile picture URL
  Future<String> getProfilePictureUrl(String userId) async {
    try {
      Reference ref = userProfilePicturesRef.child('$userId.jpg');
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // Return default profile picture URL
        return 'https://firebasestorage.googleapis.com/v0/b/tennis-training-app.appspot.com/o/default_profile.png?alt=media';
      }
      throw Exception('Failed to get profile picture: $e');
    }
  }

  // Upload training video
  Future<String> uploadTrainingVideo(String userId, String filePath) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference ref = _firebaseService.storage
          .ref()
          .child('training_videos')
          .child(userId)
          .child(fileName);
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload training video: $e');
    }
  }

  // Delete training video
  Future<void> deleteTrainingVideo(String userId, String videoUrl) async {
    try {
      Reference ref = _firebaseService.storage.refFromURL(videoUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete training video: $e');
    }
  }
}