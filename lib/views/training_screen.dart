import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_training_app/controllers/training_session_controller.dart';
import 'package:tennis_training_app/core/app_colors.dart';
import 'package:tennis_training_app/core/app_constants.dart';
import 'package:tennis_training_app/services/auth_service.dart';
import 'package:tennis_training_app/models/training_session_model.dart';
import 'package:tennis_training_app/models/user_model.dart';
import 'package:tennis_training_app/services/training_session_service.dart';
import 'package:tennis_training_app/widgets/session_card.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final List<String> sessionTypes = [
    'Forehand',
    'Backhand',
    'Serve',
    'Volley',
    'Smash',
    'Footwork',
    'Match Practice',
    'Fitness'
  ];

  String _selectedSessionType = 'All';
  bool _isLoading = true;
  List<TrainingSessionModel> _sessions = [];
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final sessionService = Provider.of<TrainingSessionService>(context, listen: false);
      
      if (authService.currentUser != null) {
        List<TrainingSessionModel> sessions =
            await sessionService.getUserSessions(authService.currentUser!.uid);
        Map<String, dynamic> stats =
            await sessionService.getSessionStatistics(authService.currentUser!.uid);

        setState(() {
          _sessions = sessions;
          _statistics = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading sessions: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<TrainingSessionModel> get _filteredSessions {
    if (_selectedSessionType == 'All') {
      return _sessions;
    }
    return _sessions
        .where((session) => session.sessionType == _selectedSessionType.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatisticsCard(),
                _buildSessionTypeFilter(),
                Expanded(
                  child: _filteredSessions.isEmpty
                      ? _buildEmptyState()
                      : _buildSessionsList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewSession,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Training Overview",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  _statistics['totalSessions']?.toString() ?? '0',
                  'Sessions',
                ),
                _buildStatItem(
                  _statistics['totalDuration'] != null
                      ? '${(_statistics['totalDuration'] / 60).toStringAsFixed(1)}h'
                      : '0h',
                  'Total Time',
                ),
                _buildStatItem(
                  _statistics['averageRating']?.toStringAsFixed(1) ?? '0.0',
                  'Avg Rating',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTypeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedSessionType,
        decoration: InputDecoration(
          labelText: "Filter by Session Type",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: ['All', ...sessionTypes].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSessionType = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildSessionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSessions.length,
      itemBuilder: (context, index) {
        return SessionCard(session: _filteredSessions[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_tennis,
            size: 64,
            color: AppColors.primaryGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No training sessions yet",
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start your first session to track your progress",
            style: GoogleFonts.roboto(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startNewSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Start Training",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startNewSession() {
    // Navigate to new session screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildSessionTypeSelector(),
    );
  }

  Widget _buildSessionTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Session Type",
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: sessionTypes.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToSessionDetail(sessionTypes[index]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  sessionTypes[index],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _navigateToSessionDetail(String sessionType) {
    // Navigate to session detail screen
    // This would be implemented in a separate screen
    print("Starting $sessionType session");
  }
}