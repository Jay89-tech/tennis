import 'package:flutter/material.dart';
import 'package:tennis_training_app/core/app_colors.dart';
import 'package:tennis_training_app/core/app_constants.dart';
import 'package:tennis_training_app/widgets/tennis_loading_animation.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

// Update the build method to use the tennis loading animation
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.primaryGreen,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_tennis,
              size: 60,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 30),
          // App Name
          Text(
            AppConstants.appName,
            style: GoogleFonts.robotoCondensed(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 50),
          // Tennis Animation - Using Lottie version
          const TennisLoadingAnimation(size: 120),
          // Or use the simple version:
          // const SimpleTennisLoading(size: 120),
          const SizedBox(height: 30),
          // Loading Text
          Text(
            "Loading...",
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    ),
  );
}}