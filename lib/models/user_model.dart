// File: lib/models/user_model.dart
class UserModel {
  final String? uid;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? contactNumber;
  final DateTime createdAt;

  UserModel({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.contactNumber,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get fullName => '$firstName $lastName';

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? contactNumber,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
