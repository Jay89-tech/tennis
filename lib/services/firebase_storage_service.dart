import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:tennis_training_app/services/firebase_service.dart';

class FirebaseStorageService {
  final FirebaseService _firebaseService = FirebaseService();

  // Reference to the root storage bucket
  Reference get storageRef => _firebaseService.storage.ref();

  // Reference to user profile pictures
  Reference get userProfilePicturesRef => storageRef.child('profile_pictures');

  // Reference to training videos
  Reference get trainingVideosRef => storageRef.child('training_videos');

  // Reference to training images
  Reference get trainingImagesRef => storageRef.child('training_images');

  // Reference to match recordings
  Reference get matchRecordingsRef => storageRef.child('match_recordings');

  // Reference to app assets
  Reference get appAssetsRef => storageRef.child('app_assets');

  // Upload a file with progress tracking
  Future<UploadTask> uploadFile({
    required String filePath,
    required String storagePath,
    SettableMetadata? metadata,
    void Function(TaskSnapshot)? onProgress,
  }) async {
    try {
      File file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      Reference ref = storageRef.child(storagePath);
      UploadTask uploadTask = ref.putFile(file, metadata);

      // Listen for progress if callback provided
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          onProgress(snapshot);
        });
      }

      return uploadTask;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Upload user profile picture
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      String extension = path.extension(filePath);
      String fileName = '$userId$extension';
      Reference ref = userProfilePicturesRef.child(fileName);

      // Upload the file
      await ref.putFile(File(filePath));

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // Upload training video
  Future<String> uploadTrainingVideo(String userId, String filePath, {String? customName}) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = customName ?? 'training_$timestamp.mp4';
      Reference ref = trainingVideosRef.child(userId).child(fileName);

      // Upload the file
      await ref.putFile(File(filePath));

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload training video: $e');
    }
  }

  // Upload training image
  Future<String> uploadTrainingImage(String userId, String filePath, {String? customName}) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = path.extension(filePath);
      String fileName = customName ?? 'image_$timestamp$extension';
      Reference ref = trainingImagesRef.child(userId).child(fileName);

      // Upload the file
      await ref.putFile(File(filePath));

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload training image: $e');
    }
  }

  // Upload match recording
  Future<String> uploadMatchRecording(String userId, String filePath, {String? matchId}) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = matchId != null ? 'match_$matchId.mp4' : 'match_$timestamp.mp4';
      Reference ref = matchRecordingsRef.child(userId).child(fileName);

      // Upload the file
      await ref.putFile(File(filePath));

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload match recording: $e');
    }
  }

  // Get download URL for a file
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        throw Exception('File not found: $storagePath');
      }
      throw Exception('Failed to get download URL: $e');
    }
  }

  // Get user profile picture URL
  Future<String> getProfilePictureUrl(String userId) async {
    try {
      // Try common image extensions
      final extensions = ['.jpg', '.jpeg', '.png', '.webp'];
      
      for (String extension in extensions) {
        try {
          Reference ref = userProfilePicturesRef.child('$userId$extension');
          return await ref.getDownloadURL();
        } on FirebaseException catch (e) {
          if (e.code != 'object-not-found') {
            rethrow;
          }
        }
      }
      
      // If no profile picture found, return default
      return await getDefaultProfilePictureUrl();
    } catch (e) {
      throw Exception('Failed to get profile picture URL: $e');
    }
  }

  // Get default profile picture URL
  Future<String> getDefaultProfilePictureUrl() async {
    try {
      Reference ref = appAssetsRef.child('default_profile.png');
      return await ref.getDownloadURL();
    } catch (e) {
      // Fallback to a generic default image
      return 'https://firebasestorage.googleapis.com/v0/b/tennis-training-app.appspot.com/o/app_assets%2Fdefault_profile.png?alt=media';
    }
  }

  // List files in a directory
  Future<List<Reference>> listFiles(String directoryPath) async {
    try {
      Reference ref = storageRef.child(directoryPath);
      ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  // List user training videos
  Future<List<Reference>> listUserTrainingVideos(String userId) async {
    try {
      Reference ref = trainingVideosRef.child(userId);
      ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list training videos: $e');
    }
  }

  // List user training images
  Future<List<Reference>> listUserTrainingImages(String userId) async {
    try {
      Reference ref = trainingImagesRef.child(userId);
      ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list training images: $e');
    }
  }

  // List user match recordings
  Future<List<Reference>> listUserMatchRecordings(String userId) async {
    try {
      Reference ref = matchRecordingsRef.child(userId);
      ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list match recordings: $e');
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String storagePath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  // Update file metadata
  Future<FullMetadata> updateFileMetadata(String storagePath, SettableMetadata metadata) async {
    try {
      Reference ref = storageRef.child(storagePath);
      return await ref.updateMetadata(metadata);
    } catch (e) {
      throw Exception('Failed to update file metadata: $e');
    }
  }

  // Delete a file
  Future<void> deleteFile(String storagePath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        throw Exception('File not found: $storagePath');
      }
      throw Exception('Failed to delete file: $e');
    }
  }

  // Delete user profile picture
  Future<void> deleteProfilePicture(String userId) async {
    try {
      // Try to delete all possible extensions
      final extensions = ['.jpg', '.jpeg', '.png', '.webp'];
      
      for (String extension in extensions) {
        try {
          Reference ref = userProfilePicturesRef.child('$userId$extension');
          await ref.delete();
        } on FirebaseException catch (e) {
          if (e.code != 'object-not-found') {
            rethrow;
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  // Delete training video
  Future<void> deleteTrainingVideo(String userId, String videoName) async {
    try {
      Reference ref = trainingVideosRef.child(userId).child(videoName);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete training video: $e');
    }
  }

  // Delete training image
  Future<void> deleteTrainingImage(String userId, String imageName) async {
    try {
      Reference ref = trainingImagesRef.child(userId).child(imageName);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete training image: $e');
    }
  }

  // Delete match recording
  Future<void> deleteMatchRecording(String userId, String recordingName) async {
    try {
      Reference ref = matchRecordingsRef.child(userId).child(recordingName);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete match recording: $e');
    }
  }

  // Get file size
  Future<int> getFileSize(String storagePath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      return await ref.getMetadata().then((metadata) => metadata.size ?? 0);
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  // Check if file exists
  Future<bool> fileExists(String storagePath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      await ref.getDownloadURL();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false;
      }
      throw Exception('Failed to check file existence: $e');
    }
  }

  // Download file to local path
  Future<File> downloadFile(String storagePath, String localPath) async {
    try {
      Reference ref = storageRef.child(storagePath);
      await ref.writeToFile(File(localPath));
      return File(localPath);
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Get storage usage for a user
  Future<Map<String, dynamic>> getUserStorageUsage(String userId) async {
    try {
      int totalSize = 0;
      int videoCount = 0;
      int imageCount = 0;
      int recordingCount = 0;

      // Calculate training videos size
      try {
        List<Reference> videos = await listUserTrainingVideos(userId);
        videoCount = videos.length;
        for (Reference video in videos) {
          totalSize += await getFileSize(video.fullPath);
        }
      } catch (e) {
        // Ignore if folder doesn't exist
      }

      // Calculate training images size
      try {
        List<Reference> images = await listUserTrainingImages(userId);
        imageCount = images.length;
        for (Reference image in images) {
          totalSize += await getFileSize(image.fullPath);
        }
      } catch (e) {
        // Ignore if folder doesn't exist
      }

      // Calculate match recordings size
      try {
        List<Reference> recordings = await listUserMatchRecordings(userId);
        recordingCount = recordings.length;
        for (Reference recording in recordings) {
          totalSize += await getFileSize(recording.fullPath);
        }
      } catch (e) {
        // Ignore if folder doesn't exist
      }

      return {
        'totalSize': totalSize,
        'videoCount': videoCount,
        'imageCount': imageCount,
        'recordingCount': recordingCount,
        'formattedSize': _formatBytes(totalSize),
      };
    } catch (e) {
      throw Exception('Failed to calculate storage usage: $e');
    }
  }

  // Format bytes to human-readable format
  String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}