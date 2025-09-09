import 'package:tennis_training_app/models/training_session_model.dart';
import 'package:tennis_training_app/services/training_session_service.dart';

class TrainingSessionController {
  final TrainingSessionService _sessionService;

  TrainingSessionController({required TrainingSessionService sessionService})
      : _sessionService = sessionService;

  // Create a new training session
  Future<void> createTrainingSession(TrainingSessionModel session) async {
    return await _sessionService.createSession(session);
  }

  // Get user sessions
  Future<List<TrainingSessionModel>> getUserSessions(String userId) async {
    return await _sessionService.getUserSessions(userId);
  }

  // Get sessions by type
  Future<List<TrainingSessionModel>> getSessionsByType(
      String userId, String sessionType) async {
    return await _sessionService.getSessionsByType(userId, sessionType);
  }

  // Update session
  Future<void> updateSession(TrainingSessionModel session) async {
    return await _sessionService.updateSession(session);
  }

  // Delete session
  Future<void> deleteSession(String sessionId) async {
    return await _sessionService.deleteSession(sessionId);
  }

  // Get session statistics
  Future<Map<String, dynamic>> getSessionStatistics(String userId) async {
    return await _sessionService.getSessionStatistics(userId);
  }

  // Get sessions in date range
  Future<List<TrainingSessionModel>> getSessionsInDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    return await _sessionService.getSessionsInDateRange(userId, startDate, endDate);
  }

  // Stream of user sessions
  Stream<List<TrainingSessionModel>> getUserSessionsStream(String userId) {
    return _sessionService.getUserSessionsStream(userId);
  }
}