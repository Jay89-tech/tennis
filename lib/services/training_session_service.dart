import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_training_app/models/training_session_model.dart';
import 'package:tennis_training_app/services/firebase_service.dart';

class TrainingSessionService {
  final FirebaseService _firebaseService = FirebaseService();

  // Collection reference
  CollectionReference<TrainingSessionModel> get sessionsCollection =>
      _firebaseService.firestore
          .collection('training_sessions')
          .withConverter<TrainingSessionModel>(
            fromFirestore: (snapshot, _) =>
                TrainingSessionModel.fromMap(snapshot.data()!),
            toFirestore: (session, _) => session.toMap(),
          );

  // Create a new training session
  Future<void> createSession(TrainingSessionModel session) async {
    try {
      await sessionsCollection.doc(session.id).set(session);
    } catch (e) {
      throw Exception('Failed to create training session: $e');
    }
  }

  // Get session by ID
  Future<TrainingSessionModel> getSession(String sessionId) async {
    try {
      DocumentSnapshot<TrainingSessionModel> snapshot =
          await sessionsCollection.doc(sessionId).get();
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception('Training session not found');
      }
    } catch (e) {
      throw Exception('Failed to get training session: $e');
    }
  }

  // Get all sessions for a user
  Future<List<TrainingSessionModel>> getUserSessions(String userId) async {
    try {
      QuerySnapshot<TrainingSessionModel> snapshot = await sessionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get user sessions: $e');
    }
  }

  // Get sessions by type
  Future<List<TrainingSessionModel>> getSessionsByType(
      String userId, String sessionType) async {
    try {
      QuerySnapshot<TrainingSessionModel> snapshot = await sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('sessionType', isEqualTo: sessionType)
          .orderBy('startTime', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get sessions by type: $e');
    }
  }

  // Update session
  Future<void> updateSession(TrainingSessionModel session) async {
    try {
      await sessionsCollection.doc(session.id).update(session.toMap());
    } catch (e) {
      throw Exception('Failed to update training session: $e');
    }
  }

  // Delete session
  Future<void> deleteSession(String sessionId) async {
    try {
      await sessionsCollection.doc(sessionId).delete();
    } catch (e) {
      throw Exception('Failed to delete training session: $e');
    }
  }

  // Get sessions within date range
  Future<List<TrainingSessionModel>> getSessionsInDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot<TrainingSessionModel> snapshot = await sessionsCollection
          .where('userId', isEqualTo: userId)
          .where('startTime', isGreaterThanOrEqualTo: startDate)
          .where('startTime', isLessThanOrEqualTo: endDate)
          .orderBy('startTime', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get sessions in date range: $e');
    }
  }

  // Get session statistics
  Future<Map<String, dynamic>> getSessionStatistics(String userId) async {
    try {
      List<TrainingSessionModel> sessions = await getUserSessions(userId);
      
      int totalSessions = sessions.length;
      int totalDuration = sessions.fold(0, (sum, session) => sum + session.duration);
      int forehandCount = sessions.where((s) => s.sessionType == 'forehand').length;
      int backhandCount = sessions.where((s) => s.sessionType == 'backhand').length;
      int serveCount = sessions.where((s) => s.sessionType == 'serve').length;
      
      double averageRating = sessions.isNotEmpty
          ? sessions.fold(0.0, (sum, session) => sum + session.rating) / sessions.length
          : 0.0;

      return {
        'totalSessions': totalSessions,
        'totalDuration': totalDuration,
        'forehandCount': forehandCount,
        'backhandCount': backhandCount,
        'serveCount': serveCount,
        'averageRating': averageRating,
        'averageSessionDuration': totalSessions > 0 ? totalDuration / totalSessions : 0,
      };
    } catch (e) {
      throw Exception('Failed to get session statistics: $e');
    }
  }

  // Stream of user sessions
  Stream<List<TrainingSessionModel>> getUserSessionsStream(String userId) {
    return sessionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}