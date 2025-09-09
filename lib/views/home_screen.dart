import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_training_app/controllers/auth_controller.dart';
import 'package:tennis_training_app/core/app_colors.dart';
import 'package:tennis_training_app/core/app_constants.dart';
import 'package:tennis_training_app/models/user_model.dart';
import 'package:tennis_training_app/services/auth_service.dart';
import 'package:tennis_training_app/services/user_service.dart';
import 'package:tennis_training_app/widgets/tennis_loading_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      
      if (authService.currentUser != null) {
        UserModel user = await userService.getUser(authService.currentUser!.uid);
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TennisLoadingAnimation(),
              const SizedBox(height: 20),
              Text(
                "Loading your tennis journey...",
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      title: Text(
        AppConstants.appName,
        style: GoogleFonts.robotoCondensed(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Navigate to notifications screen
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildTrainingSection();
      case 2:
        return _buildMatchesSection();
      case 3:
        return _buildProfileSection();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildRecentActivities(),
          const SizedBox(height: 20),
          _buildProgressOverview(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryGreen,
              backgroundImage: _currentUser?.profilePictureUrl != null
                  ? CachedNetworkImageProvider(_currentUser!.profilePictureUrl!)
                  : null,
              child: _currentUser?.profilePictureUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back, ${_currentUser?.firstName ?? 'Tennis Player'}!",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ready to improve your game today?",
                    style: GoogleFonts.roboto(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildActionCard(
              icon: Icons.videocam,
              title: "Record Session",
              color: AppColors.accentGreen,
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.analytics,
              title: "View Progress",
              color: Colors.orange,
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.calendar_today,
              title: "Schedule",
              color: Colors.blue,
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.people,
              title: "Find Partner",
              color: Colors.purple,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activities",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "View All",
                style: GoogleFonts.roboto(
                  color: AppColors.accentGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildActivityItem(index);
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        "title": "Forehand Practice",
        "subtitle": "30 minutes • 85% accuracy",
        "icon": Icons.sports_tennis,
        "color": AppColors.primaryGreen,
      },
      {
        "title": "Backhand Drills",
        "subtitle": "45 minutes • 78% accuracy",
        "icon": Icons.rotate_left,
        "color": Colors.blue,
      },
      {
        "title": "Serve Practice",
        "subtitle": "25 minutes • 92% accuracy",
        "icon": Icons.trending_up,
        "color": Colors.orange,
      },
    ];

    final activity = activities[index];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: activity["color"] as Color,
          child: Icon(
            activity["icon"] as IconData,
            color: Colors.white,
          ),
        ),
        title: Text(
          activity["title"] as String,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          activity["subtitle"] as String,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppColors.darkGrey,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Weekly Progress",
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
                _buildProgressStat("4h 30m", "Training Time"),
                _buildProgressStat("85%", "Accuracy"),
                _buildProgressStat("12", "Sessions"),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: AppColors.lightGreen,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Goal: 6h",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
                Text(
                  "75% Complete",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String value, String label) {
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

  Widget _buildTrainingSection() {
    return Center(
      child: Text(
        "Training Section - Coming Soon",
        style: GoogleFonts.roboto(
          fontSize: 18,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildMatchesSection() {
    return Center(
      child: Text(
        "Matches Section - Coming Soon",
        style: GoogleFonts.roboto(
          fontSize: 18,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Text(
        "Profile Section - Coming Soon",
        style: GoogleFonts.roboto(
          fontSize: 18,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_tennis),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Start a new training session
      },
      backgroundColor: AppColors.primaryGreen,
      child: const Icon(Icons.add, size: 30),
    );
  }

  Future<void> _signOut() async {
    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}