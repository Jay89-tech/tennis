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
  final int? skillLevel; // 0-3: Beginner to Professional
  final String? playingStyle;
  final String? favoriteCourt;
  final bool? trainingReminders;
  final bool? progressNotifications;
  final bool? emailUpdates;

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
    this.trainingReminders = true,
    this.progressNotifications = true,
    this.emailUpdates = false,
  });

  // Convert to Map (update to include new fields)
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
      'trainingReminders': trainingReminders,
      'progressNotifications': progressNotifications,
      'emailUpdates': emailUpdates,
    };
  }

  // Create from Map (update to include new fields)
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
      trainingReminders: map['trainingReminders'] ?? true,
      progressNotifications: map['progressNotifications'] ?? true,
      emailUpdates: map['emailUpdates'] ?? false,
    );
  }

  // Copy with method (update to include new fields)
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? contactNumber,
    String? profilePictureUrl,
    int? skillLevel,
    String? playingStyle,
    String? favoriteCourt,
    bool? trainingReminders,
    bool? progressNotifications,
    bool? emailUpdates,
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
      updatedAt: DateTime.now(),
      skillLevel: skillLevel ?? this.skillLevel,
      playingStyle: playingStyle ?? this.playingStyle,
      favoriteCourt: favoriteCourt ?? this.favoriteCourt,
      trainingReminders: trainingReminders ?? this.trainingReminders,
      progressNotifications: progressNotifications ?? this.progressNotifications,
      emailUpdates: emailUpdates ?? this.emailUpdates,
    );
  }
}