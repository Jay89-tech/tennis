class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String? contactNumber;
  final String? profilePictureUrl;
  final DateTime createdAt;
  DateTime updatedAt;
  final int? skillLevel;
  final String? playingStyle;
  final String? favoriteCourt;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.contactNumber,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    this.skillLevel,
    this.playingStyle,
    this.favoriteCourt,
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username.toLowerCase(),
      'contactNumber': contactNumber,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'skillLevel': skillLevel,
      'playingStyle': playingStyle,
      'favoriteCourt': favoriteCourt,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      contactNumber: map['contactNumber'],
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      skillLevel: map['skillLevel'],
      playingStyle: map['playingStyle'],
      favoriteCourt: map['favoriteCourt'],
    );
  }

  // Copy with method for updating fields
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? contactNumber,
    String? profilePictureUrl,
    int? skillLevel,
    String? playingStyle,
    String? favoriteCourt,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      contactNumber: contactNumber ?? this.contactNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      skillLevel: skillLevel ?? this.skillLevel,
      playingStyle: playingStyle ?? this.playingStyle,
      favoriteCourt: favoriteCourt ?? this.favoriteCourt,
    );
  }
}