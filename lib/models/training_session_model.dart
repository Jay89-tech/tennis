class TrainingSessionModel {
  final String id;
  final String userId;
  final String sessionType;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in minutes
  final Map<String, dynamic> metrics;
  final List<String> videoUrls;
  final List<String> imageUrls;
  final String notes;
  final double rating;
  final DateTime createdAt;

  TrainingSessionModel({
    required this.id,
    required this.userId,
    required this.sessionType,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.metrics,
    this.videoUrls = const [],
    this.imageUrls = const [],
    this.notes = '',
    this.rating = 0.0,
    required this.createdAt,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sessionType': sessionType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'metrics': metrics,
      'videoUrls': videoUrls,
      'imageUrls': imageUrls,
      'notes': notes,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory TrainingSessionModel.fromMap(Map<String, dynamic> map) {
    return TrainingSessionModel(
      id: map['id'],
      userId: map['userId'],
      sessionType: map['sessionType'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      duration: map['duration'],
      metrics: Map<String, dynamic>.from(map['metrics']),
      videoUrls: List<String>.from(map['videoUrls']),
      imageUrls: List<String>.from(map['imageUrls']),
      notes: map['notes'],
      rating: map['rating']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Copy with method
  TrainingSessionModel copyWith({
    String? id,
    String? userId,
    String? sessionType,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    Map<String, dynamic>? metrics,
    List<String>? videoUrls,
    List<String>? imageUrls,
    String? notes,
    double? rating,
    DateTime? createdAt,
  }) {
    return TrainingSessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionType: sessionType ?? this.sessionType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      metrics: metrics ?? this.metrics,
      videoUrls: videoUrls ?? this.videoUrls,
      imageUrls: imageUrls ?? this.imageUrls,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}