import 'dart:io';
import 'package:tennis_training_app/services/firebase_storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  final FirebaseStorageService _storageService;

  StorageController({required FirebaseStorageService storageService})
      : _storageService = storageService;

  // Upload profile picture
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    return await _storageService.uploadProfilePicture(userId, filePath);
  }

  // Upload training video
  Future<String> uploadTrainingVideo(String userId, String filePath, {String? customName}) async {
    return await _storageService.uploadTrainingVideo(userId, filePath, customName: customName);
  }

  // Upload training image
  Future<String> uploadTrainingImage(String userId, String filePath, {String? customName}) async {
    return await _storageService.uploadTrainingImage(userId, filePath, customName: customName);
  }

  // Upload match recording
  Future<String> uploadMatchRecording(String userId, String filePath, {String? matchId}) async {
    return await _storageService.uploadMatchRecording(userId, filePath, matchId: matchId);
  }

  // Get profile picture URL
  Future<String> getProfilePictureUrl(String userId) async {
    return await _storageService.getProfilePictureUrl(userId);
  }

  // List user training videos
  Future<List<Reference>> listUserTrainingVideos(String userId) async {
    return await _storageService.listUserTrainingVideos(userId);
  }

  // List user training images
  Future<List<Reference>> listUserTrainingImages(String userId) async {
    return await _storageService.listUserTrainingImages(userId);
  }

  // List user match recordings
  Future<List<Reference>> listUserMatchRecordings(String userId) async {
    return await _storageService.listUserMatchRecordings(userId);
  }

  // Delete profile picture
  Future<void> deleteProfilePicture(String userId) async {
    return await _storageService.deleteProfilePicture(userId);
  }

  // Delete training video
  Future<void> deleteTrainingVideo(String userId, String videoName) async {
    return await _storageService.deleteTrainingVideo(userId, videoName);
  }

  // Delete training image
  Future<void> deleteTrainingImage(String userId, String imageName) async {
    return await _storageService.deleteTrainingImage(userId, imageName);
  }

  // Delete match recording
  Future<void> deleteMatchRecording(String userId, String recordingName) async {
    return await _storageService.deleteMatchRecording(userId, recordingName);
  }

  // Get user storage usage
  Future<Map<String, dynamic>> getUserStorageUsage(String userId) async {
    return await _storageService.getUserStorageUsage(userId);
  }

  // Download file
  Future<File> downloadFile(String storagePath, String localPath) async {
    return await _storageService.downloadFile(storagePath, localPath);
  }

  // Check if file exists
  Future<bool> fileExists(String storagePath) async {
    return await _storageService.fileExists(storagePath);
  }
}