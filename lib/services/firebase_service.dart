import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;

  FirebaseService._internal();

  factory FirebaseService() {
    _instance ??= FirebaseService._internal();
    return _instance!;
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
  }

  FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception('FirebaseService not initialized. Call initialize() first.');
    }
    return _auth!;
  }

  FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('FirebaseService not initialized. Call initialize() first.');
    }
    return _firestore!;
  }

  FirebaseStorage get storage {
    if (_storage == null) {
      throw Exception('FirebaseService not initialized. Call initialize() first.');
    }
    return _storage!;
  }
}