// refactored_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_training_app/controllers/auth_controller.dart';
import 'package:tennis_training_app/controllers/storage_controller.dart';
import 'package:tennis_training_app/controllers/training_session_controller.dart';
import 'package:tennis_training_app/core/app_colors.dart';
import 'package:tennis_training_app/core/app_constants.dart';
import 'package:tennis_training_app/models/user_model.dart';
import 'package:tennis_training_app/services/auth_service.dart';
import 'package:tennis_training_app/services/user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _currentUser;
  bool _isLoading = true;
  Map<String, dynamic> _statistics = {};
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final sessionController = Provider.of<TrainingSessionController>(context, listen: false);
      
      if (authService.currentUser != null) {
        UserModel user = await userService.getUser(authService.currentUser!.uid);
        Map<String, dynamic> stats = await sessionController.getSessionStatistics(authService.currentUser!.uid);

        if (mounted) {
          setState(() {
            _currentUser = user;
            _statistics = stats;
            _isLoading = false;
          });
        }
      } else {
         if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _uploadProfilePicture();
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null || _currentUser == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Uploading image...'),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      final storageController = Provider.of<StorageController>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      
      String imageUrl = await storageController.uploadProfilePicture(
        _currentUser!.uid,
        _selectedImage!.path,
      );

      UserModel updatedUser = _currentUser!.copyWith(profilePictureUrl: imageUrl);
      await userService.updateUser(updatedUser);

      if (mounted) {
        setState(() {
          _currentUser = updatedUser;
          _selectedImage = null;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload profile picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const EditProfileSheet(),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const SettingsSheet(),
    );
  }

  Future<void> _signOut() async {
    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.signOut();
      // Ensure the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightGreen,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            _buildProfileActions(),
            const SizedBox(height: 24),
            _buildTrainingPreferences(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryGreen,
                  backgroundImage: _currentUser?.profilePictureUrl != null
                      ? CachedNetworkImageProvider(_currentUser!.profilePictureUrl!)
                      : null,
                  child: _currentUser?.profilePictureUrl == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${_currentUser?.firstName ?? ''} ${_currentUser?.lastName ?? ''}',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@${_currentUser?.username ?? ''}',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            if (_currentUser?.contactNumber != null)
              Text(
                _currentUser!.contactNumber!,
                style: GoogleFonts.roboto(
                  color: AppColors.darkGrey,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Statistics',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            StatCard(
              title: 'Total Sessions',
              value: _statistics['totalSessions']?.toString() ?? '0',
              icon: Icons.sports_tennis,
              color: AppColors.primaryGreen,
            ),
            StatCard(
              title: 'Total Hours',
              value: _statistics['totalDuration'] != null
                  ? '${(_statistics['totalDuration'] / 60).toStringAsFixed(1)}h'
                  : '0h',
              icon: Icons.timer,
              color: Colors.blue,
            ),
            StatCard(
              title: 'Avg Rating',
              value: _statistics['averageRating']?.toStringAsFixed(1) ?? '0.0',
              icon: Icons.star,
              color: Colors.orange,
            ),
            StatCard(
              title: 'Forehand',
              value: _statistics['forehandCount']?.toString() ?? '0',
              icon: Icons.trending_up,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.settings,
                title: 'Settings',
                onTap: _showSettings,
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: _signOut,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Preferences',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPreferenceItem(
                  'Skill Level',
                  _currentUser?.skillLevel != null
                      ? AppConstants.skillLevels[_currentUser!.skillLevel!]
                      : 'Not set',
                ),
                const SizedBox(height: 12),
                _buildPreferenceItem(
                  'Playing Style',
                  _currentUser?.playingStyle ?? 'Not set',
                ),
                const SizedBox(height: 12),
                _buildPreferenceItem(
                  'Favorite Court',
                  _currentUser?.favoriteCourt ?? 'Not set',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primaryGreen),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildPreferenceItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// Separate Widgets for Sheets and Cards for better maintainability
// -------------------------------------------------------------

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Edit functionality will be implemented in the next version',
            style: GoogleFonts.roboto(color: AppColors.darkGrey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  bool _trainingReminders = true;
  bool _progressNotifications = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingSwitch(
            'Training Reminders',
            _trainingReminders,
            (newValue) {
              setState(() {
                _trainingReminders = newValue;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildSettingSwitch(
            'Progress Notifications',
            _progressNotifications,
            (newValue) {
              setState(() {
                _progressNotifications = newValue;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildSettingSwitch(
            'Email Updates',
            _emailUpdates,
            (newValue) {
              setState(() {
                _emailUpdates = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            'App Version: 1.0.0',
            style: GoogleFonts.roboto(color: AppColors.darkGrey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryGreen,
        ),
      ],
    );
  }
}